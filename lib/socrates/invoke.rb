require 'fileutils'

module Socrates
  class << self
    def invoke(course_path, destination = '.')
      if course_path[0] != '/'
        course_path = Dir.getwd + '/' + course_path
      end

      # Create theme.yml
      
      FileUtils.mkdir_p destination

      FileUtils.cp File.dirname(__FILE__) + '/views/striped/theme.yml', destination + '/theme.yml'

      # Read assignments.yml and create a stub invocation.yml

      information = Socrates::Models::Information.load(course_path + '/information.yml')
      assignments = Socrates::Models::Assignments.load(course_path + '/assignments.yml')
      File.open(destination + '/invocation.yml', 'w') do |f|
        f.write "# Invocation Information for " + information.title + "\n"
        f.write "course path: " + course_path + "\n"
        f.write "\n"
        f.write "# Course Information\n"
        f.write "\n"
        f.write "# Uncomment to specify\n"
        f.write "# Anywhere there is an array, you may specify as many items as you'd like\n"
        f.write "\n"
        f.write "course:\n"
        f.write "  title: " + information.title + "\n"
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
end
