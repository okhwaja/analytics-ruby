require 'mongoose/analytics/version'
require 'mongoose/analytics/defaults'
require 'mongoose/analytics/utils'
require 'mongoose/analytics/field_parser'
require 'mongoose/analytics/client'
require 'mongoose/analytics/worker'
require 'mongoose/analytics/transport'
require 'mongoose/analytics/response'
require 'mongoose/analytics/logging'

module Mongoose
  class Analytics
    # Initializes a new instance of {Mongoose::Analytics::Client}, to which all
    # method calls are proxied.
    #
    # @param options includes options that are passed down to
    #   {Mongoose::Analytics::Client#initialize}
    # @option options [Boolean] :stub (false) If true, requests don't hit the
    #   server and are stubbed to be successful.
    def initialize(options = {})
      Transport.stub = options[:stub] if options.has_key?(:stub)
      @client = Mongoose::Analytics::Client.new options
    end

    def method_missing(message, *args, &block)
      if @client.respond_to? message
        @client.send message, *args, &block
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @client.respond_to?(method_name) || super
    end

    include Logging
  end
end
