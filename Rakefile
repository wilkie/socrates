require 'rake'
require 'rspec/core/rake_task'

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

task :default do
end
