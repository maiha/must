# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "must/version"

Gem::Specification.new do |s|
  s.name        = "must"
  s.version     = Must::VERSION
  s.license     = 'MIT'
  s.authors     = ["maiha"]
  s.email       = ["maiha@wota.jp"]
  s.homepage    = "http://github.com/maiha/must"
  s.summary     = %q{a runtime specification tool}
  s.description = %q{add Object#must method to constrain its origin and conversions}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
end
