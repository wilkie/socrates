require 'yaml'

module Socrates
	module Models
		class Information
			attr_reader :configuration_file

			def self.load(configuration_file)
				if not defined?(@@instances)
					@@instances = {}
				end

				if @@instances[configuration_file] == nil
					info = Information.new
					info.load(configuration_file)
					@@instances[configuration_file] = info
				end

				@@instances[configuration_file]
			end

			def load(configuration_file)
				@config = YAML.load_file(configuration_file)
				@configuration_file = configuration_file
			end

			def title
				@config["title"]
			end
		end
	end
end

