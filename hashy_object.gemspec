# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hashy_object/version"

Gem::Specification.new do |s|
  s.name        = "hashy_object"
  s.version     = HashyObject::VERSION
  s.authors     = ["Chris Apolzon"]
  s.email       = ["apolzon@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Generate a hash-like string representation of any Ruby object}
  s.description = %q{Generate a hash-like string representation of any Ruby object}

  s.rubyforge_project = "hashy_object"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "mocha"
end
