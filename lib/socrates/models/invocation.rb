require 'yaml'

require_relative 'assignments'

class Invocation
	attr_accessor :configuration_file
	attr_accessor :assignments

	def self.load(assignments, configuration_file)
		if not defined?(@@instances)
			@@instances = {}
		end

		key = assignments.configuration_file + configuration_file
		if @@instances[key] == nil
			invocation = Invocation.new
			invocation.load(assignments, configuration_file)
			@@instances[key] = invocation
		end

		@@instances[key]
	end

	private :load
	def load(assignments, configuration_file)
		@invocation = YAML.load_file(configuration_file)
		self.configuration_file = configuration_file
		self.assignments = assignments
	end

	def types
		@invocation.keys
	end

	def list(type)
		data = self.assignments.list(type)
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
