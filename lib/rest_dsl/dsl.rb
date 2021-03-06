require 'json'
require 'psych'

module RestDSL

  ##
  # A collection of DSL extensions for use with various worlds to allow the use of some simpler
  # dsl language in them.
  #
  # For rspec, in spec helper add config.extend RestDSL::DSLExtensions::<<extension>>
  # In cucumber World(RestDSL::DSLExtensions::<<extension>>)
  # Each extension can also be extended onto a class like normal to use it in that class
  module DSLExtensions

    ##
    # Adds a DSL method for parsing information from a file, parser list can be overridden by redefining file_parsers
    # If no parser is designed, for the file extension, loads the file as plain text
    module FromFile

      def file_parsers
        {
          %w[.json] => JSON,
          %w[.yml .yaml] => Psych
        }
      end

      def from_file(file_name)
        parser = file_parsers.find{|key, _| key.any? {|file_type| file_name.include? file_type}}&.[](1)
        result = if parser.eql?(Psych)
                   parser.load_file(file_name)
                 elsif parser.eql?(JSON)
                   parser.parse(File.read(file_name))
                 end
        result ||= File.new(file_name)
        result
      rescue Errno::ENOENT => e
        e.message << " relative to directory #{Dir.pwd}"
        raise e
      end
    end
  end
end