# invoke_spec.rb

require_relative '../lib/socrates.rb'

describe Socrates do
	describe "#invoke" do
		it "should generate an invocation.yml file in the specified directory" do
			if File.exists?('test/invocation.yml')
				File.delete('test/invocation.yml')
			end
			Socrates.invoke('test/course', 'test')
			File.exists?('test/invocation.yml').should eql(true)
			if File.exists?('test/invocation.yml')
				File.delete('test/invocation.yml')
			end
		end

		it "should generate an invocation.yml file in the current directory if no destination is given" do
			Dir.chdir('test')
			if File.exists?('invocation.yml')
				File.delete('invocation.yml')
			end
			Socrates.invoke('test/course')
			File.exists?('invocation.yml').should eql(true)
			if File.exists?('invocation.yml')
				File.delete('invocation.yml')
			end
			Dir.chdir('..')
		end
	end
end
