require_relative '../models/information'
require_relative '../models/schedule'

class SiteController
	def schedule
		schedule = Schedule.instance

		@dates = schedule.dates
		@lectures = schedule.lectures
	end

	def information
		information = Information.instance

		@course[:teachers] = information.teachers
		@course[:assistants] = information.assistants
		@course[:start_date] = information.start_date
		@course[:end_date] = information.end_date

		@course[:days] = information.days
	end

	def assignments
	end
end
