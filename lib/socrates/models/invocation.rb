require 'yaml'

require_relative 'assignments'

class Invocation
	def self.instance
		@@last_loaded
	end

	def initialize(configuration_file)
		@@last_loaded = self
		@invocation = YAML.load_file(configuration_file)
	end

	def types
		@invocation.keys
	end

	def list(type)
		data = Assignments.instance.list(type)
		@invocation[type].map do |hash|
			result = {}
			result[:title] = hash["title"]

			if hash["assigned"] != nil
				result[:assigned] = hash["assigned"]
			end

			if hash["due"] != nil
				result[:due] = hash["due"]
			end

			if hash["week of"] != nil
				result[:week_of] = hash["week of"]
			end

			items = data.select do |item|
				item[:title] == hash["title"]
			end

			item = items[0]

			result[:description] = item[:description]
			result[:href] = item[:href]

			result
		end
	end
end
