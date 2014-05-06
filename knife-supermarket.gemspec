# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require "knife-supermarket/version"

Gem::Specification.new do |s|
  s.name        = 'knife-supermarket'
  s.version     = Knife::Supermarket::VERSION
  s.summary     = %q{Knife support for interacting with Chef Supermarkets}
  s.description = s.summary
  s.authors     = ["Christopher Webber"]
  s.email       = 'cwebber@getchef.com'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/cwebberOps/knife-supermarket'
  s.license       = 'Apache 2.0'
  s.require_paths = ["lib"]
  s.add_dependency "chef", ">= 0.10.10"
end
