# Controller

class Controller
	def initialize(model, title)
		@site = model
		@title = title
	end

	def header
		@course = {}
		@course[:number] = @site.config["number"]
		@course[:title] = @site.config["title"]
	end

	def information
		@course[:teacher] = @site.config["teacher"]
		@course[:assistants] = @site.config["assistants"]
		@course[:start_date] = @site.config["start date"]
		@course[:end_date] = @site.config["end date"]

		start_time = @site.config["start time"]
		start_time = Time.new(0, nil, nil, start_time / 60, start_time % 60)

		@course[:start_time] = start_time.strftime("%l:%M%P").strip

		end_time = @site.config["end time"]
		end_time = Time.new(0, nil, nil, end_time / 60, end_time % 60)

		@course[:end_time] = end_time.strftime("%l:%M%P").strip

		@course[:days] = @site.config["days"].inject("") do |result, element|
			result + element + ", "
		end
		@course[:days] = @course[:days][0..-3]
	end

	def schedule
		# Get array of Date foo
		@no_class_dates = @site.config["no class"]

		@days = @site.config["days"].map { |s| s.capitalize }
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

		@start_date = @site.config["start date"]
		@end_date = @site.config["end date"]

		@dates = (@start_date..@end_date).select do |date|
			days_mask & (1 << date.wday) > 0 and not @no_class_dates.include?(date)
		end

		i = 0
		@lectures = @site.schedule.map do |lecture|
			result = {}
			result[:title] = lecture["title"]
			result[:description] = lecture["description"]
			if lecture["slides"] == nil
				result[:slides] = []
			elsif not lecture["slides"].instance_of? Array
				result[:slides] = [lecture["slides"]]
			else
				result[:slides] = lecture["slides"]
			end

			if lecture["notes"] == nil
				result[:notes] = []
			elsif not lecture["notes"].instance_of? Array
				result[:notes] = [lecture["notes"]]
			else
				result[:notes] = lecture["notes"]
			end

			if lecture["links"] == nil
				result[:links] = []
			elsif not lecture["links"].instance_of? Array
				result[:links] = [lecture["links"]]
			else
				result[:links] = lecture["links"]
			end

			# reform slides array
			result[:slides] = result[:slides].map do |slide|
				new_slide = {}
				if slide.instance_of? Hash
					new_slide[:title] = slide["title"]
					new_slide[:files] = slide["files"]
				else
					new_slide[:title] = "Slides"
					new_slide[:files] = slide
				end

				# Reform files array
			
				# The ideal situation is an array of slides, each consisting of
				#   a tuple (filename, title)
				if not new_slide[:files].instance_of? Array
					new_slide[:files] = [new_slide[:files]]
				end

				# For each Slide tuple...
				new_slide[:files] = new_slide[:files].map do |list|
					# Ok, if it isn't a tuple, make it one
					if not list.instance_of? Array
						list = [list, ""]
					end

					{:href => list[0], :title => list[1]}
				end

				new_slide
			end

			# reform links array
			result[:links] = result[:links].map do |link|
				{:title => link["title"], :href => link["href"]}
			end

			# reform notes array
			result[:notes] = result[:notes].map do |note|
				new_note = {}
				if note.instance_of? Hash
					new_note[:title] = note["title"]
					new_note[:files] = note["files"]
				else
					new_note[:title] = "Notes"
					new_note[:files] = note
				end

				# Reform files array
			
				# The ideal situation is an array of notes, each consisting of
				#   a tuple (filename, title)
				if not new_note[:files].instance_of? Array
					new_note[:files] = [new_note[:files]]
				end

				# For each Slide tuple...
				new_note[:files] = new_note[:files].map do |list|
					# Ok, if it isn't a tuple, make it one
					if not list.instance_of? Array
						list = [list, ""]
					end

					{:href => list[0], :title => list[1]}
				end

				new_note
			end

			# Get a list of class dates
			result[:date] = @dates[i]
			result[:full_date] = result[:date].strftime("%A, %B ")
			result[:full_date] += result[:date].strftime("%e").strip
			append = "th"
			if result[:date].strftime("%e")[-2] == '1'
			elsif result[:date].strftime("%e")[-1] == '1'
				append = "st"
			elsif result[:date].strftime("%e")[-1] == '2'
				append = "nd"
			elsif result[:date].strftime("%e")[-1] == '3'
				append = "rd"
			end
			result[:full_date] += append + result[:date].strftime(", %Y")
			i = i + 1
			result
		end
	end
end
