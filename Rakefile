require 'rake'
require 'rspec/core/rake_task'

# rake gemspec
begin
	require 'jeweler'
	
	Jeweler::Tasks.new do |gem|
		gem.name = "socrates"
		gem.homepage = "http://github.com/wilkie/socrates"
		gem.license = "CC0"
		gem.summary = %q{Creates static sites for educational courses}
		gem.description = %q{Be able to sparsely describe a course and generate a static website to present the course materials with a variety of themes}
		gem.email = "wilkie05@gmail.com"
		gem.authors = ["wilkie"]
	end

	Jeweler::GemcutterTasks.new

rescue LoadError
	puts "Please install the jeweler gem by using: gem install jeweler OR using: bundle install"
end

# rake spec
RSpec::Core::RakeTask.new(:spec) do |t|
	t.pattern = 'spec/*_spec.rb'
	t.rspec_opts = '--backtrace' 
end

# rake documentation
RSpec::Core::RakeTask.new(:documentation) do |t|
	t.pattern = 'spec/*_spec.rb'
	t.rspec_opts = '--format documentation' 
end

# rake withTheme[plain]
task :withTheme, [:theme] do
end

task :default => [:withTheme]
