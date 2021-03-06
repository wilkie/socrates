require 'socrates/models/invocation'

module Socrates
  module Models
    class Schedule
      attr_reader :invocation
      attr_reader :configuration_file

      def self.load(invocation, configuration_file)
        if not defined?(@@instances)
          @@instances = {}
        end

        key = invocation.configuration_file + configuration_file
        if @@instances[key] == nil
          sched = Schedule.new
          sched.load(invocation, configuration_file)
          @@instances[key] = sched
        end

        @@instances[key]
      end

      def load(invocation, configuration_file)
        @invocation = invocation
        @schedule = YAML.load_file(configuration_file)
        @configuration_file = configuration_file
      end

      def dates
        if invocation.start_date == nil or invocation.end_date == nil
          return []
        end

        # Get array of Date foo
        no_class_dates = invocation.no_class

        days_mask = invocation.days.inject(0) do |result, num| 
          result | (1 << num)
        end

        (invocation.start_date..invocation.end_date).select do |date|
          days_mask & (1 << date.wday) > 0 and not no_class_dates.include?(date)
        end
      end

      def lectures
        # Crazy (terrible) code to rake the yaml file and produce a nice array
        # consisting of all of the lecture invocation contained in the schedule
        i = 0
        all_dates = self.dates
        @schedule.map do |lecture|
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

          if lecture["videos"] == nil
            result[:videos] = []
          elsif not lecture["videos"].instance_of? Array
            result[:videos] = [lecture["videos"]]
          else
            result[:videos] = lecture["videos"]
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

          # reform videos array
          result[:videos] = result[:videos].map do |video|
            {:title => video["title"], :href => video["href"]}
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
          if all_dates != []
            result[:date] = all_dates[i]

            # Get the "full date"
            # This is a helper...
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
          end

          if lecture["optional"] != nil and lecture["optional"] == "yes"
            result[:optional] = true
          else
            result[:optional] = false
          end

          i = i + 1
          result
        end
      end
    end
  end
end
