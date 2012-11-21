# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cucumber/api_steps/version"

Gem::Specification.new do |s|
  s.name        = "cucumber-api-steps"
  s.version     = Cucumber::ApiSteps::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jay Zeschin"]
  s.email       = ["jay.zeschin@modeset.com"]
  s.homepage    = "http://github.com/jayzes/cucumber-api-steps"
  s.summary     = %q{Cucumber steps to easily test REST-based XML and JSON APIs}
  s.description = %q{Cucumber steps to easily test REST-based XML and JSON APIs}

  s.add_dependency              'jsonpath', '>= 0.1.2'
  s.add_dependency              'cucumber',  '>= 1.2.1'
  s.add_dependency              'rspec',  '>= 2.12.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
