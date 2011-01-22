# Controller

class Controller
	def initialize(model, title)
		@site = model
		@title = title
	end

	def header
		@course = {}
		@course[:number] = @site.config["course"]["number"]
		@course[:title] = @site.config["course"]["title"]
	end

	def information
		@course[:teacher] = @site.config["course"]["teacher"]
		@course[:assistants] = @site.config["course"]["assistants"]
		@course[:start_date] = @site.config["course"]["start date"]
		@course[:end_date] = @site.config["course"]["end date"]

		start_time = @site.config["course"]["start time"]
		start_time = Time.new(0, nil, nil, start_time / 60, start_time % 60)

		@course[:start_time] = start_time.strftime("%l:%M%P").strip

		end_time = @site.config["course"]["end time"]
		end_time = Time.new(0, nil, nil, end_time / 60, end_time % 60)

		@course[:end_time] = end_time.strftime("%l:%M%P").strip
	end

	def schedule
		# Get array of Date foo
		no_class_dates = @site.config["course"]["no class"]

		@days = @site.config["course"]["days"].map { |s| s.capitalize }
		days_mask = @days.inject(0) do |result, str| 
			if str == "Sunday"
				result | 1
			elsif str == "Monday"
				result | 2
			elsif str == "Tuesday"
				result | 4
			elsif str == "Wednesday"
				result | 8
			elsif str == "Thursday"
				result | 16
			elsif str == "Friday"
				result | 32
			elsif str == "Saturday"
				result | 64
			end
		end

		@start_date = @site.config["course"]["start date"]
		@end_date = @site.config["course"]["end date"]

		@dates = (@start_date..@end_date).select do |date|
			days_mask & (1 << date.wday) > 0
		end
	end
end
