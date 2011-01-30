# invocation_spec.rb

require_relative '../lib/socrates/models/invocation'

describe Socrates::Models::Invocation do
	before(:each) do
		@assignments = Socrates::Models::Assignments.load('test/assignments/normal.yml')
		@normal = Socrates::Models::Invocation.load(@assignments, 'test/invocation/normal.yml')
		@empty = Socrates::Models::Invocation.load(@assignments, 'test/invocation/empty.yml')
	end

	describe "#title" do
		it "returns N/A when the course title is not given in the yaml file" do
			@empty.title.should eql("N/A")
		end

		it "returns the course title given in the yaml file" do
			@normal.title.should eql("Introduction to Programming")
		end
	end

	describe "#number" do
		it "returns N/A when the course number is not given in the yaml file" do
			@empty.number.should eql("N/A")
		end

		it "returns the course number given in the yaml file" do
			@normal.number.should eql("CS 0007")
		end
	end

	# It is lenient about the plurization of the term and whether or not the value is plural
	describe "#assistants" do
		it "returns an empty array when assistants are not given in the yaml file" do
			@empty.assistants.should eql([])
		end

		it "returns the assistants that are given in the yaml file when one is listed as assistant" do
			invocation = Socrates::Models::Invocation.load(@assignments, "test/invocation/single_teacher.yml")
			invocation.assistants[0].should eql("Mykolas Dapkus")
		end

		it "returns the assistants that are given in the yaml file when more than one is listed as assistant" do
			invocation = Socrates::Models::Invocation.load(@assignments, "test/invocation/multiple_teacher.yml")
			invocation.assistants[0].should eql("Mykolas Dapkus")
			invocation.assistants[1].should eql("Jane Smith")
		end

		it "returns the assistants that are given in the yaml file when one is listed as assistants" do
			invocation = Socrates::Models::Invocation.load(@assignments, "test/invocation/single_teachers.yml")
			invocation.assistants[0].should eql("Mykolas Dapkus")
		end

		it "returns the assistants that are given in the yaml file when more than one is listed as assistants" do
			invocation = Socrates::Models::Invocation.load(@assignments, "test/invocation/multiple_teachers.yml")
			invocation.assistants[0].should eql("Mykolas Dapkus")
			invocation.assistants[1].should eql("Jane Smith")
		end
	end

	# It is lenient about the plurization of the term and whether or not the value is plural
	describe "#teachers" do
		it "returns an empty array when teachers are not given in the yaml file" do
			@empty.teachers.should eql([])
		end

		it "returns the teachers that are given in the yaml file when one is listed as teacher" do
			invocation = Socrates::Models::Invocation.load(@assignments, "test/invocation/single_teacher.yml")
			invocation.teachers[0].should eql("Dave Wilkinson")
		end

		it "returns the teachers that are given in the yaml file when more than one is listed as teacher" do
			invocation = Socrates::Models::Invocation.load(@assignments, "test/invocation/multiple_teacher.yml")
			invocation.teachers[0].should eql("Dave Wilkinson")
			invocation.teachers[1].should eql("John Smith")
		end

		it "returns the teachers that are given in the yaml file when one is listed as teachers" do
			invocation = Socrates::Models::Invocation.load(@assignments, "test/invocation/single_teachers.yml")
			invocation.teachers[0].should eql("Dave Wilkinson")
		end

		it "returns the teachers that are given in the yaml file when more than one is listed as teachers" do
			invocation = Socrates::Models::Invocation.load(@assignments, "test/invocation/multiple_teachers.yml")
			invocation.teachers[0].should eql("Dave Wilkinson")
			invocation.teachers[1].should eql("John Smith")
		end
	end

	describe "#start_time" do
		it "should return midnight when the start time is not given" do
			@empty.start_time.should eql(Time.new(0, nil, nil, 0, 0))
		end

		it "should return a Time instance" do
			@normal.start_time.instance_of?(Time).should eql(true)
		end

		it "should represent the time in the yaml file" do
			@normal.start_time.should eql(Time.new(0, nil, nil, 16, 30))
		end
	end

	describe "#end_time" do
		it "should return midnight when the end time is not given" do
			@empty.end_time.should eql(Time.new(0, nil, nil, 0, 0))
		end

		it "should return a Time instance" do
			@normal.end_time.instance_of?(Time).should eql(true)
		end

		it "should represent the time in the yaml file" do
			@normal.end_time.should eql(Time.new(0, nil, nil, 17, 45))
		end
	end

	describe "#end_date" do
		it "should return a Date instance" do
			@normal.end_date.instance_of?(Date).should eql(true)
		end

		it "should represent the date in the yaml file" do
			@normal.end_date.should eql(Date.parse('2011-04-20'))
		end
	end
	
	describe "#start_date" do
		it "should return a Date instance" do
			@normal.start_date.instance_of?(Date).should eql(true)
		end

		it "should represent the date in the yaml file" do
			@normal.start_date.should eql(Date.parse('2011-01-05'))
		end
	end

	describe "#days" do
		it "should give an empty array when days is not given" do
			@empty.days.should eql([])
		end

		it "should give an array of values representing the days it meets where 0 is sunday" do
			@normal.days.should eql([1,3])
		end

		it "should work when days contains a single value" do
			invocation = Socrates::Models::Invocation.load(@assignments, "test/invocation/single_day.yml")
			invocation.days.should eql([6])
		end
	end

	describe "#no_class" do
		it "should give an array of Date instances" do
			@normal.no_class.instance_of?(Array).should eql(true)
			@normal.no_class[0].instance_of?(Date).should eql(true)
		end

		it "should represent the dates given in the yaml file" do
			@normal.no_class.should eql([Date.parse('2011-01-17'), Date.parse('2011-03-07'), Date.parse('2011-03-09')])
		end
	end

	describe "#types" do
		it "should give the sections given by the yaml file" do
			@normal.types.should eql(["homework", "labs", "projects"])
		end
	end

	describe "#list" do
		it "should yield the items given by the yaml file" do
			@normal.list("homework").should eql([
				{ :title => "Picobot", :description => "Solving some Picobot puzzles", :href => "homework/hw1",
		   			:assigned => Date.parse('2011-01-11'), :due => Date.parse('2011-01-21')},
				{ :title => "ISP", :description => "Billing program for a good-natured ISP", :href => "homework/hw2",
		   			:assigned => Date.parse('2011-01-25'), :due => Date.parse('2011-02-04')}])
		end

		it "should handle the use of week_of in the yaml file" do
			@normal.list("labs").should eql([
				{ :title => "Picobot", :description => "Playing around with the Picobot", :href => "labs/picobot",
					:week_of => Date.parse('2011-01-10') },
				{ :title => "Calorie Counter", :description => "Writing a program to track diet statistics that do not matter", :href => "labs/calorie_counter",
					:week_of => Date.parse('2011-01-24') }])
		end
	end
end
