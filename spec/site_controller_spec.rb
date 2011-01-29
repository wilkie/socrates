# site_controller.rb
require_relative '../lib/socrates/controllers/site_controller'

describe SiteController do
	before(:each) do
		@controller = SiteController.new
	end

	describe "#schedule" do
		it "should exist" do
			@controller.public_methods.include?(:schedule).should eql(true)
		end
	end
end
