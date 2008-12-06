require 'java'
include_class 'java.net.URL'
include_class 'com.gargoylesoftware.htmlunit.WebClient'
include_class 'com.gargoylesoftware.htmlunit.HttpWebConnection'
include_class 'com.gargoylesoftware.htmlunit.HttpMethod'
include_class 'com.gargoylesoftware.htmlunit.WebRequestSettings'
include_class 'org.apache.commons.httpclient.NameValuePair'
module Webrat
  class HtmlUnitSession
    attr_accessor :response
    alias :page :response
    
    def initialize()
      @connection = HttpWebConnection.new(WebClient.new)
    end
    
    def get(url, data)
      request(url, 'get', data)
    end
    
    def post(url, data)
      request(url, 'post', data)
    end
    
    def response_code
      @response.get_status_code
    end
    
    def response_body
      @response.get_content_as_string
    end
    
    def request(url, verb, params, headers = nil)    
      settings = WebRequestSettings.new(URL.new(url), http_method('get'))
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