require_relative '../socrates'
require 'optparse'

module Socrates
	class CLI
		BANNER = <<-USAGE
		Usage:
		  socrates invoke COURSE_PATH [DESTINATION_PATH='.']
		  socrates scaffold COURSE_NAME
		USAGE

		class << self
			def set_options
				@opts = OptionParser.new do |opts|
					opts.banner = BANNER.gsub(/^\s{2}/, '')

					opts.separator ''
					opts.separator 'Options:'

					opts.on('-h', '--help', 'Display this help') do
						puts opts
						exit
					end
				end

				@opts.parse!
			end

			def run
				set_options

				def fail
					puts @opts
					exit
				end

				if ARGV.empty?
					fail
				end

				case ARGV.first
				when 'invoke'
					fail unless ARGV[1]
					Socrates.invoke(ARGV[1])
				when 'scaffold'
				end
			end
		end
	end
end
