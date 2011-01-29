# specs/information.rb
require_relative '../models/information'

describe Information do
	before(:each) do
		# This represents a common course description:
		@normal = Information.new("test/information/normal.yml")
	end

	describe "#title" do
		it "returns the course title given in the yaml file" do
			@normal.title.should eql("Introduction to Programming")
		end
	end

	describe "#number" do
		it "returns the course number given in the yaml file" do
			@normal.number.should eql("CS 0007")
		end
	end

	# It is lenient about the plurization of the term and whether or not the value is plural
	describe "#assistants" do
		it "returns the assistants that are given in the yaml file when one is listed as assistant" do
			information = Information.new("test/information/single_teacher.yml")
			information.assistants[0].should eql("Mykolas Dapkus")
		end

		it "returns the teachers that are given in the yaml file when more than one is listed as assistant" do
			information = Information.new("test/information/multiple_teacher.yml")
			information.assistants[0].should eql("Mykolas Dapkus")
			information.assistants[1].should eql("Jane Smith")
		end

		it "returns the teachers that are given in the yaml file when one is listed as assistants" do
			information = Information.new("test/information/single_teachers.yml")
			information.assistants[0].should eql("Mykolas Dapkus")
		end

		it "returns the teachers that are given in the yaml file when more than one is listed as assistants" do
			information = Information.new("test/information/multiple_teachers.yml")
			information.assistants[0].should eql("Mykolas Dapkus")
			information.assistants[1].should eql("Jane Smith")
		end
	end

	# It is lenient about the plurization of the term and whether or not the value is plural
	describe "#teachers" do
		it "returns the teachers that are given in the yaml file when one is listed as teacher" do
			information = Information.new("test/information/single_teacher.yml")
			information.teachers[0].should eql("Dave Wilkinson")
		end

		it "returns the teachers that are given in the yaml file when more than one is listed as teacher" do
			information = Information.new("test/information/multiple_teacher.yml")
			information.teachers[0].should eql("Dave Wilkinson")
			information.teachers[1].should eql("John Smith")
		end

		it "returns the teachers that are given in the yaml file when one is listed as teachers" do
			information = Information.new("test/information/single_teachers.yml")
			information.teachers[0].should eql("Dave Wilkinson")
		end

		it "returns the teachers that are given in the yaml file when more than one is listed as teachers" do
			information = Information.new("test/information/multiple_teachers.yml")
			information.teachers[0].should eql("Dave Wilkinson")
			information.teachers[1].should eql("John Smith")
		end
	end

	describe "#start_time" do
		it "should return a Time instance" do
			@normal.start_time.instance_of?(Time).should eql(true)
		end

		it "should represent the time in the yaml file" do
			@normal.start_time.should eql(Time.new(0, nil, nil, 16, 30))
		end
	end

	describe "#end_time" do
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
		it "should give an array of values representing the days it meets where 0 is sunday" do
			@normal.days.should eql([1,3])
		end

		it "should work when days contains a single value" do
			information = Information.new("test/information/single_day.yml")
			information.days.should eql([6])
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
end
