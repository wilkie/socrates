# invoke_spec.rb

require_relative '../lib/socrates.rb'

describe Socrates do
	describe "#invoke" do
		before(:each) do
			if File.exists?('test/invocation.yml')
				File.delete('test/invocation.yml')
			end
			if File.exists?('test/theme.yml')
				File.delete('test/theme.yml')
			end
		end

		after(:each) do
			if File.exists?('test/invocation.yml')
				File.delete('test/invocation.yml')
			end
			if File.exists?('test/theme.yml')
				File.delete('test/theme.yml')
			end
		end
		
		it "should generate a theme.yml file in the specified directory" do
			Socrates.invoke('test/course', 'test')
			File.exists?('test/theme.yml').should eql(true)
		end

		it "should generate a theme.yml file in the current directory if no destination is given" do
			Dir.chdir('test')
			Socrates.invoke('test/course')
			File.exists?('theme.yml').should eql(true)
			Dir.chdir('..')
		end 

		it "should generate an invocation.yml file in the specified directory" do
			Socrates.invoke('test/course', 'test')
			File.exists?('test/invocation.yml').should eql(true)
		end

		it "should generate an invocation.yml file in the current directory if no destination is given" do
			Dir.chdir('test')
			Socrates.invoke('test/course')
			File.exists?('invocation.yml').should eql(true)
			Dir.chdir('..')
		end
	end
end
