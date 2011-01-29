require 'rubygems'
require 'yaml'

require_relative 'socrates/generator'
require_relative 'socrates/invoke'

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
