# invocation_spec.rb

require_relative '../lib/socrates/models/invocation'

describe Invocation do
	before(:each) do
		assignments = Assignments.load('test/assignments/normal.yml')
		@normal = Invocation.load(assignments, 'test/invocation/normal.yml')
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
