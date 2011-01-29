require 'yaml'

class Assignments
	def self.instance
		@@last_loaded
	end

	def initialize(configuration_file)
		@@last_loaded = self
		@assignments = YAML.load_file(configuration_file)
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
