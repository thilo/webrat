require "webrat"

Jars = Dir[File.dirname(__FILE__) + '/html_unit/jars/*.jar']

if RUBY_PLATFORM =~ /java/
  require 'java'
  Jars.each { |jar| require(jar) }
  
  module HtmlUnit
    include_package 'com.gargoylesoftware.htmlunit'
  end
  JavaString = java.lang.String
else
  raise "RubyHtmlUnit only works on JRuby at the moment."
end

Dir[File.join(File.dirname(__FILE__), "html_unit", "*.rb")].each do |file|
  require File.expand_path(file)
end
