require 'socrates'
require 'optparse'

module Socrates
  class CLI
    BANNER = <<-USAGE
    Usage:
      socrates invoke COURSE_PATH [DESTINATION_PATH='.']
      socrates scaffold COURSE_NAME
      socrates generate [OUTPUT_PATH='.']

    Description:
      The 'invoke' command will spawn a new instance of a course given by COURSE_PATH
      and generate an invocation.yml file which is tailored to the course information.

      The 'scaffold' command will generate empty yaml files that can be used to
      describe a new course. A directory will be created of name COURSE_NAME to hold
      the files. The path of this directory can then be used with 'invoke' to create
      and instance of this course.

      The 'generate' command will produce the final pages using the information found
      in the configuration files and using the theme chosen.
    USAGE

    class << self
      def parse_options
        @opts = OptionParser.new do |opts|
          opts.banner = BANNER.gsub(/^\t{2}/, '')

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
        begin
          parse_options
        rescue OptionParser::InvalidOption => e
          warn e
          exit -1
        end

        def fail
          puts @opts
          exit -1
        end

        if ARGV.empty?
          fail
        end

        case ARGV.first
        when 'invoke'
          fail unless ARGV[1]
          dest = '.'
          dest = ARGV[2] unless not ARGV[2]
          Socrates.invoke(ARGV[1], dest)
        when 'scaffold'
          fail unless ARGV[1]
          dest = '.'
          dest = ARGV[1]
          Socrates.scaffold(dest)
        when 'generate'
          dest = '.'
          dest = ARGV[1] unless not ARGV[1]
          Socrates.generate(nil, dest)
        end
      end
    end
  end
end
