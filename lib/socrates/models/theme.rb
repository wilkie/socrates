module Socrates
	module Models
		class Theme
			attr_reader :configuration_file

			def self.load(configuration_file)
				if not defined?(@@instances)
					@@instances = {}
				end

				if @@instances[configuration_file] == nil
					info = Theme.new
					info.load(configuration_file)
					@@instances[configuration_file] = info
				end

				@@instances[configuration_file]
			end

			def load(configuration_file)
				@config = YAML.load_file(configuration_file)
				@configuration_file = configuration_file
			end

			def name
				@config["name"]
			end
		end
	end
end

