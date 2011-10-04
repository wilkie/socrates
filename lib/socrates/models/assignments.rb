require 'yaml'

module Socrates
  module Models
    class Assignments
      attr_reader :configuration_file

      def self.load(configuration_file)
        if not defined?(@@instances)
          @@instances = {}
        end

        key = configuration_file
        if @@instances[key] == nil
          assigns = Assignments.new
          assigns.load(configuration_file)
          @@instances[key] = assigns
        end

        @@instances[key]
      end

      def load(configuration_file)
        @assignments = YAML.load_file(configuration_file)
        @configuration_file = configuration_file
      end

      def types
        @assignments.keys
      end

      def list(type)
        @assignments[type].map do |assignment|
          result = {}
          result[:title] = assignment["title"]
          result[:href] = assignment["href"]
          result[:description] = assignment["description"]
          result
        end
      end
    end
  end
end
