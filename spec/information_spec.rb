# specs/information.rb
require_relative '../lib/socrates/models/information'

describe Socrates::Models::Information do
	before(:each) do
		# This represents a common course description:
		@normal = Socrates::Models::Information.load("test/information/normal.yml")
	end

	describe "#title" do
		it "returns the course title given in the yaml file" do
			@normal.title.should eql("Introduction to Programming")
		end
	end
end
