require_relative 'rest_dsl/version'
require_relative 'rest_dsl/errors'
require 'psych'
require 'json'

module RestDSL
  class << self
    attr_reader :config_file_location
    attr_reader :use_config_file
    attr_reader :config

    def config_file_location=(arg)
      @config_file_location = arg
      load_config
    end

    def default_configs
      {}
    end

    def configuration
      @config
    end

    private
    def load_config
      @config =
        if File.exist?("#{config_file_location}/rest_dsl.yml")
          Psych.load_file("#{config_file_location}/rest_dsl.yml")
        else
          default_configs
        end
    end
  end

  @config_file_location = './config'
  load_config

end