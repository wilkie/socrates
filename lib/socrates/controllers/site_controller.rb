require_relative '../models/information'
require_relative '../models/schedule'

require_relative '../generator'

module Socrates
	module Controllers
		class SiteController
			def initialize(generator, title = '', path = '', theme_path = '')
				@generator = generator
				@title = title
				@path = path
				@theme_path = theme_path
			end

			def header
				invocation = @generator.invocation

				@course = {}

				@course[:number] = invocation.number
				@course[:title] = invocation.title
			end

			def navigation
				@assignment_types = @generator.invocation.types
				p @assignment_types
			end

			def schedule
				schedule = @generator.schedule

				@dates = schedule.dates
				@lectures = schedule.lectures
			end

			def information
				invocation = @generator.invocation

				@course[:teachers] = invocation.teachers
				@course[:assistants] = invocation.assistants
				@course[:start_date] = invocation.start_date
				@course[:end_date] = invocation.end_date
				@course[:start_time] = invocation.start_time
				@course[:end_time] = invocation.end_time
				p @course

				@course[:days] = invocation.days.inject("") do |result, num|
					# A date that is Sunday
					foo = Date.parse('2011-01-02')
					foo = foo + num
					result = result + foo.strftime('%A') + ", "
				end

				if @course[:days] != ""
					@course[:days] = @course[:days][0..-3]
				end
			end

			def assignments(type = '')
				assignments = @generator.assignments
				@assignments = assignments.list(type)
			end
		end
	end
end
