require_relative 'models/information'
require_relative 'models/schedule'
require_relative 'models/assignments'
require_relative 'models/invocation'

module Socrates
	class Generator
		def initialize(files)
			if not Socrates.settings.keys.include? :course_path
				course_path = '.'
			else
				course_path = Socrates.settings[:course_path]
			end
			if not files.keys.include? :information
				files[:information] = course_path + '/information.yml'
			end
			if not files.keys.include? :schedule
				files[:schedule] = course_path + '/schedule.yml'
			end
			if not files.keys.include? :assignments
				files[:assignments] = course_path + '/assignments.yml'
			end
			if not files.keys.include? :invocation
				files[:invocation] = './invocation.yml'
			end
			if not files.keys.include? :theme
				files[:theme] = 'striped'
			end

			puts files
			Models::Information.new(files[:information])
			Models::Schedule.new(files[:schedule])
			Models::Assignments.new(files[:assignments])
			Models::Invocation.new(files[:invocation])
		end

		def generate
		end
	end
end
