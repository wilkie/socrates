# theme_spec.rb
require_relative '../lib/socrates/models/theme'

describe Socrates::Models::Theme do
	before(:each) do
		# This represents a common course description:
		@normal = Socrates::Models::Theme.load("test/theme/normal.yml")
	end

	describe "#name" do
		it "returns the name of the theme" do
			@normal.name.should eql("striped")
		end
	end
end

