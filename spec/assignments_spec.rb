require_relative '../lib/socrates/models/assignments'

describe Assignments do
	before(:each) do
		@normal = Assignments.load('test/assignments/normal.yml')
	end

	describe "#types" do
		it "should give the sections given by the yaml file" do
			@normal.types.should eql(["homework", "labs", "projects"])
		end
	end

	describe "#list" do
		it "should yield the items given by the yaml file" do
			@normal.list("homework").should eql([
				{ :title => "Picobot", :description => "Solving some Picobot puzzles", :href => "homework/hw1" },
				{ :title => "ISP", :description => "Billing program for a good-natured ISP", :href => "homework/hw2" },
				{ :title => "A Simple Title", :description => "A short introduction to the nature of the assignment", :href => "homework/hw3" }])
		end
	end
end
