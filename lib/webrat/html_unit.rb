puts 'HEEEEEEEEEEEEEER'
require "webrat"
require "action_controller/integration"

Jars = Dir[File.dirname(__FILE__) + '/html_unit/jars/*.jar']

if RUBY_PLATFORM =~ /java/
  require 'java'
  Jars.each { |jar| require(jar) }
  include_class 'java.net.URL'
  include_class 'com.gargoylesoftware.htmlunit.WebClient'
  include_class 'com.gargoylesoftware.htmlunit.HttpWebConnection'
  include_class 'com.gargoylesoftware.htmlunit.HttpMethod'
  include_class 'com.gargoylesoftware.htmlunit.WebRequestSettings'
  include_class 'org.apache.commons.httpclient.NameValuePair'
  JavaString = java.lang.String
else
  raise "RubyHtmlUnit only works on JRuby at the moment."
end

module Webrat
  class HtmlUnitSession  < Session
    puts 'ARGGGG!'
    attr_accessor :response
    alias :page :response
    
    def initialize(context = nil)
      
      super
      if context.is_a?(HttpWebConnection)
        @connection = context 
      else
        @client = WebClient.new
        @connection = HttpWebConnection.new(@client)
      end
      puts @connection
    end
    
    def get(url, data, header = nil)
      request(url, 'get', data)
    end
    
    def post(url, data, header = nil)
      request(url, 'post', data)
    end
    
    def response_code
      @response.get_status_code
    end
    
    def response_body
      @response.get_content_as_string
    end
    
    def request(url, verb, params, headers = nil)    
      settings = WebRequestSettings.new(URL.new('http://localhost:3000' + url), http_method(verb))
      settings.set_request_parameters(to_http_params(params))
      
      @response = @connection.get_response(settings)
    end
    
    def http_method(verb)
      HttpMethod.const_get "#{verb.upcase}"
    end
    
    def to_http_params(params)
      params.inject([]) do |http_params, pair|
        http_params << NameValuePair.new(pair[0].to_s,pair[1].to_s)
      end
    end
  end
end

module ActionController #:nodoc:
  IntegrationTest.class_eval do
    include Webrat::Methods
  end
end

Webrat.configuration.mode = :html_unit