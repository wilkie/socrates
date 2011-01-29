# specs/schedule.rb
require_relative '../models/schedule'

describe Schedule do
	before(:each) do
		# We need some Information model
		Information.new("test/information/normal.yml")
		# This represents a common course schedule
		@normal = Schedule.new("test/schedule/normal.yml")
	end

	describe "#lectures" do
		it "should return an array" do
			@normal.lectures.instance_of?(Array).should eql(true)
		end

		describe "resulting array" do
			before(:each) do
				@lectures = @normal.lectures
			end

			it "should contain the title of the lecture given by the yaml file" do
				@lectures[0][:title].should eql("Introductions")
			end

			it "should contain the description of the lecture given by the yaml file" do
				@lectures[0][:description].should eql("What the Course is About")
			end

			it "should contain an empty array for the slides given by the yaml file if none are given" do
				@lectures[0][:slides].should eql([])
			end

			it "should contain the information for the slides given by the yaml file" do
				@lectures[1][:slides][0].should eql({:title => "The Machine", :files => [:title => "", :href => "Lecture1_TheMachine.pdf"]})
			end

			it "should contain the information for the slides when multiple files are listed in the yaml file" do
				@lectures[2][:slides][0].should eql({:title => "What is Inside?", :files => [{:title => "1pp", :href => "Lecture2_WhatIsInside-1pp.pdf"}, {:title => "2pp", :href => "Lecture2_WhatIsInside-2pp.pdf"}, {:title => "4pp", :href => "Lecture2_WhatIsInside-4pp.pdf"}]})
			end

			it "should contain an empty array for the notes given by the yaml file if none are given" do
				@lectures[0][:notes].should eql([])
			end

			it "should contain the information for the notes given by the yaml file" do
				@lectures[1][:notes][0].should eql({:title => "Lecture Notes", :files => [:title => "", :href => "SomeNotes.html"]})
			end

			it "should contain the information for the notes when multiple files are listed in the yaml file" do
				@lectures[2][:notes][0].should eql({:title => "Architecture 101", :files => [{:title => "html", :href => "Architecture.html"}, {:title => "pdf", :href => "Architecture.pdf"}, {:title => "ps", :href => "Architecture.ps"}]})
			end

			it "should contain an empty array for the videos given by the yaml file if none are given" do
				@lectures[0][:videos].should eql([])
			end

			it "should contain an array of title, href pairs to describe videos given in the yaml file" do
				@lectures[1][:videos].should eql([
					{:title => "Demoscene Foo", :href => "http://youtube.com/1"},
					{:title => "Demoscene Two", :href => "http://youtube.com/2"},
					{:title => "Demoscene Three", :href => "http://youtube.com/3"},
					{:title => "Demoscene Four", :href => "http://youtube.com/4"},
					{:title => "Demoscene Five", :href => "http://youtube.com/5"},
					{:title => "Demoscene Six", :href => "http://youtube.com/6"}])
			end

			it "should contain an empty array for the links given by the yaml file if none are given" do
				@lectures[0][:links].should eql([])
			end

			it "should contain an array of title, href pairs to describe links given in the yaml file" do
				@lectures[1][:links].should eql([
					{:title => "String Documentation", :href => "http://download.oracle.com/javase/1.4.2/docs/api/java/lang/String.html"},
					{:title => "Scanner Documentation", :href => "http://download.oracle.com/javase/1.4.2/docs/api/java/util/Scanner.html"} ])
			end
		end
	end

	describe "#dates" do
		it "should return an array of dates" do
			@normal.dates.instance_of?(Array).should eql(true)
			@normal.dates[0].instance_of?(Date).should eql(true)
		end

		it "should give you an array of days the course will meet given by the yaml file" do
			@normal.dates.should eql([
				Date.parse('2011-01-05'), Date.parse('2011-01-10'),	Date.parse('2011-01-12'),
				Date.parse('2011-01-19'), Date.parse('2011-01-24'), Date.parse('2011-01-26'),
				Date.parse('2011-01-31'), Date.parse('2011-02-02'), Date.parse('2011-02-07'),
				Date.parse('2011-02-09'), Date.parse('2011-02-14'), Date.parse('2011-02-16'),
				Date.parse('2011-02-21'), Date.parse('2011-02-23'), Date.parse('2011-02-28'),
				Date.parse('2011-03-02'), Date.parse('2011-03-14'), Date.parse('2011-03-16'),
				Date.parse('2011-03-21'), Date.parse('2011-03-23'), Date.parse('2011-03-28'),
				Date.parse('2011-03-30'), Date.parse('2011-04-04'), Date.parse('2011-04-06'),
				Date.parse('2011-04-11'), Date.parse('2011-04-13'), Date.parse('2011-04-18'),
				Date.parse('2011-04-20')] )
		end
	end
end
