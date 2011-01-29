require 'rake'
require 'rspec/core/rake_task'

# rake jeweler
begin
	require 'jeweler'
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
