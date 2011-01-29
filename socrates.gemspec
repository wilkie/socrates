# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "socrates/version"

Gem::Specification.new do |s|
  s.name        = "socrates"
  s.version     = Socrates::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dave Wilkinson"]
  s.email       = ["wilkie05@gmail.com"]
  s.homepage    = "http://github.com/wilkie/socrates"
  s.summary     = %q{Static site generator for educational courses}
  s.description = %q{Generates themable static sites for course materials given a description of a course}

  s.rubyforge_project = "socrates"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('tilt', '>= 0.9')
  s.add_dependency('rspec', '>= 2.4')
  s.add_dependency('rake', '>= 0.8.7')
end
