require 'yaml'

class Information
	def self.instance
		@@last_loaded
	end

	def initialize(configuration_file)
		@@last_loaded = self
		@config = YAML.load_file(configuration_file)	
	end

	def title
		@config["title"]
	end

	def number
		@config["number"]
	end

	def start_time
		time = @config["start time"]
		Time.new(0, nil, nil, time / 60, time % 60)
	end

	def end_time
		time = @config["end time"]
		Time.new(0, nil, nil, time / 60, time % 60)
	end

	def start_date
		@config["start date"]
	end

	def end_date
		@config["end date"]
	end

	def assistants
		if @config["assistant"] != nil 
			if @config["assistant"].instance_of? Array
				return @config["assistant"]
			else
				return [@config["assistant"]]
			end
		elsif @config["assistants"] != nil
			if @config["assistants"].instance_of? Array
				return @config["assistants"]
			else
				return [@config["assistants"]]
			end
		end
	end

	def teachers
		if @config["teacher"] != nil 
			if @config["teacher"].instance_of? Array
				return @config["teacher"]
			else
				return [@config["teacher"]]
			end
		elsif @config["teachers"] != nil
			if @config["teachers"].instance_of? Array
				return @config["teachers"]
			else
				return [@config["teachers"]]
			end
		end
	end

	def days
		if not @config["days"].instance_of? Array
			@config["days"] = [@config["days"]]
		end

		@config["days"].map do |day|
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
		if not @config["no class"].instance_of? Array
			@config["no class"] = [@config["no class"]]
		end

		@config["no class"]
	end
end
