require 'rubygems'
require 'yaml'

require_relative 'socrates/generator'

module Socrates
	class << self
		attr_reader :settings
	end

	# :course_path - path of the static course materials (default: $CURDIR)
	#
	# :information - path of information YAML (default: :course_path/information.yml)
	# :schedule - path of schedule YAML (default: :course_path/schedule.yml)
	# :assignments - path of assignments YAML (default: :course_path/assignments.yml)
	# :invocation - path of invocation YAML (default: $CURDIR/invocation.yml)
	#
	# :theme - name of the theme to use (default: striped)
	#
	# :output - path to output files (default: $CURDIR/output)
	class << self
		def configure(settings = nil)
			if not defined? @settings
				@settings = {}
			end

			if settings != nil
				settings.keys.each do |key|
					@settings[key] = settings[key]
				end
			end
		end
	end

	# Creates empty examples files for a class invocation
	class << self
		def invoke(course_path, destination = '.')
			# Create socrates.yml

			File.open(destination + '/socrates.yml', 'w') do |f|
				f.write 'course_path: ' + course_path
			end

			# Read assignments.yml and create a stub invocation.yml

			information = Socrates::Models::Information.load(course_path + '/information.yml')
			assignments = Socrates::Models::Assignments.load(course_path + '/assignments.yml')
			File.open(destination + '/invocation.yml', 'w') do |f|
				f.write "# Invocation Information for " + information.title + "\n"
				f.write "\n"
				f.write "# Course Information\n"
				f.write "\n"
				f.write "# Uncomment to specify\n"
				f.write "# Anywhere there is an array, you may specify as many items as you'd like\n"
				f.write "\n"
				f.write "course:\n"
				f.write "#  title: " + information.title + "\n"
				f.write "#  teacher: John Smith\n"
				f.write "#  teachers: [John Smith, Jane Smith]\n"
				f.write "#  assistant: John Smith\n"
				f.write "#  assistants: [John Smith, Jane Smith]\n"
				f.write "#  start date: YYYY-MM-DD\n"
				f.write "#  end date: YYYY-MM-DD\n"
				f.write "#  start time: HH-MM\n"
				f.write "#  end time: HH-MM\n"
				f.write "#  days: [Monday, Wednesday]\n"
				f.write "#  days: Saturday\n"
				f.write "#  no class: [YYYY-MM-DD, YYYY-MM-DD]\n"
				f.write "\n"
				f.write "# Course Assignments\n"
				f.write "\n"
				f.write "# For each, uncomment if you want to include this assignment\n"
				f.write "# Use \"assigned\" and \"due\" to specify a range\n"
				f.write "# Use \"week of\" to specify that the assignment/recitation/lab is a weekly thing\n"
				f.write "\n"

				assignments.types.each do |type|
					f.write type + ":\n"
					assignments.list(type).each do |item|
						f.write "#  - title: " + item[:title] + "\n"
						f.write "#    assigned: YYYY-MM-DD\n"
						f.write "#    due: YYYY-MM-DD\n"
						f.write "#    week of: YYYY-MM-DD\n"
					end
					f.write "\n"
				end
			end
		end
	end

	# Quickly generates the site from the yaml files and renders
	# them to the output folder
	class << self
		def generate(files = nil)
			g = new_generator(files)
			g.generate
		end
	end

	# Creates a generator that will generate the site described 
	# by the configuration files
	class << self
		def new_generator(files = nil)
			if not defined?(@settings)
				configure
			end

			if files == nil
				files = @settings
			else
				@settings.keys.each do |key|
					if not files.keys.include?(key)
						files[key] = @settings[key]
					end
				end
			end

			Generator.new(files)
		end
	end
end
