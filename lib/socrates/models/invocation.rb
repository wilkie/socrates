require 'yaml'

require_relative 'assignments'

module Socrates
	module Models
		class Invocation
			attr_reader :configuration_file
			attr_reader :assignments

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

			def load(assignments, configuration_file)
				@invocation = YAML.load_file(configuration_file)
				if @invocation == false
					@invocation = {}
				end
				@configuration_file = configuration_file
				@assignments = assignments
			end

			def title
				if @invocation["course"] == nil or @invocation["course"]["title"] == nil
					"N/A"
				else
					@invocation["course"]["title"]
				end
			end

			def number
				if @invocation["course"] == nil or @invocation["course"]["number"] == nil
					"N/A"
				else
					@invocation["course"]["number"]
				end
			end

			def start_time
				if @invocation["course"] == nil or @invocation["course"]["start time"] == nil
					Time.new(0, nil, nil, 0, 0)
				else
					time = @invocation["course"]["start time"]
					Time.new(0, nil, nil, time / 60, time % 60)
				end
			end

			def end_time
				if @invocation["course"] == nil or @invocation["course"]["end time"] == nil
					Time.new(0, nil, nil, 0, 0)
				else
					time = @invocation["course"]["end time"]
					Time.new(0, nil, nil, time / 60, time % 60)
				end
			end

			def start_date
				@invocation["course"]["start date"]
			end

			def end_date
				@invocation["course"]["end date"]
			end

			def assistants
				if @invocation["course"]["assistant"] != nil 
					if @invocation["course"]["assistant"].instance_of? Array
						return @invocation["course"]["assistant"]
					else
						return [@invocation["course"]["assistant"]]
					end
				elsif @invocation["course"]["assistants"] != nil
					if @invocation["course"]["assistants"].instance_of? Array
						return @invocation["course"]["assistants"]
					else
						return [@invocation["course"]["assistants"]]
					end
				end
			end

			def teachers
				if @invocation["course"]["teacher"] != nil 
					if @invocation["course"]["teacher"].instance_of? Array
						return @invocation["course"]["teacher"]
					else
						return [@invocation["course"]["teacher"]]
					end
				elsif @invocation["course"]["teachers"] != nil
					if @invocation["course"]["teachers"].instance_of? Array
						return @invocation["course"]["teachers"]
					else
						return [@invocation["course"]["teachers"]]
					end
				end
			end

			def days
				if not @invocation["course"]["days"].instance_of? Array
					@invocation["course"]["days"] = [@invocation["course"]["days"]]
				end

				@invocation["course"]["days"].map do |day|
					if day == "Sunday"
						0
					elsif day == "Monday"
						1
					elsif day == "Tuesday"
						2
					elsif day == "Wednesday"
						3
					elsif day == "Thursday"
						4
					elsif day == "Friday"
						5
					elsif day == "Saturday"
						6
					end
				end
			end

			def no_class
				if not @invocation["course"]["no class"].instance_of? Array
					@invocation["course"]["no class"] = [@invocation["course"]["no class"]]
				end

				@invocation["course"]["no class"]
			end

			def course_path
				if @invocation["course path"] == nil
					'.'
				else
					@invocation["course path"]
				end
			end

			def types
				foo = @invocation.keys
				foo.delete("course")
				foo.delete("course path")
				foo
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
	end
end
