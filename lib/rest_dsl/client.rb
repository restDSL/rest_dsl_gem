require 'rest-client'
require 'psych'
require 'json'

module RestDSL
  class Client

    class << self
      attr_accessor :methods_without_payloads, :config_dir

      def environments
        RestDSL.configuration[:environments]
      end

    end

    attr_accessor :base_url

    @methods_without_payloads = %i[get delete head options]

    def initialize(environment = nil, base_url: nil)
      if base_url
        @base_url = base_url
      else
        environment = environment.to_sym
        environmental_info = environments.fetch(environment) do
          raise RestDSL::UndefinedEnvironmentError.new(environment, environments)
        end
        @base_url = "#{environmental_info[:url]}"
      end
    end

    def execute(method, endpoint, headers, payload: nil, **hash_args, &block)
      url = "#{@base_url}/#{endpoint}"
      args = { method: method.to_sym, url: url, headers: headers }
      args.merge!(payload: payload) if payload && method_has_payload?(method)
      args.merge!(hash_args)

      response =
        begin
          RestClient::Request.new(args).execute(&block)
        rescue RestClient::ExceptionWithResponse => e
          e.response
        end
      { response: response, parsed: JSON.parse(response, symbolize_names: true) }
    rescue JSON::ParserError => e
      { response: response, parsed: "Failed to parse, see response for more information, code was: #{response.code}, message was: #{response.body}" }
    end

    def method_has_payload?(method)
      !self.class.methods_without_payloads.include?(method)
    end

    def environments
      self.class.environments
    end

    def self.default_headers
      { accept: 'application/json' }
    end

  end
end