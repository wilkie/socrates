require_relative '../models/information'
require_relative '../models/schedule'

require_relative '../generator'

class SiteController
	def initialize(generator)
		@generator = generator
	end

	def header
		invocation = @generator.invocation

		@course = {}

		@course[:number] = invocation.number
		@course[:title] = invocation.title
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

		@course[:days] = invocation.days
	end

	def assignments
		assignments = @generator.assignments
	end
end
