# site_controller.rb
require_relative '../lib/socrates/controllers/site_controller'
require_relative '../lib/socrates/generator'

describe SiteController do
	before(:each) do
		@controller = SiteController.new(nil)
	end

	describe "#schedule" do
		it "should exist" do
			@controller.public_methods.include?(:schedule).should eql(true)
		end
	end
end
