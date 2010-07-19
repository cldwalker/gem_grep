# -*- encoding: utf-8 -*-
require 'rubygems' unless Object.const_defined?(:Gem)
require File.dirname(__FILE__) + "/lib/gem_grep/version"

Gem::Specification.new do |s|
  s.name        = "gem_grep"
  s.version     = GemGrep::VERSION
  s.authors     = ["Gabriel Horner"]
  s.email       = "gabriel.horner@gmail.com"
  s.homepage = "http://github.com/cldwalker/gem_grep"
  s.summary = "A gem command plugin which enhances the search command by providing extra search options and displaying results as a table."
  s.description = 'Enhances search command by displaying results in an ascii table and providing options to search (--fields) and display (--columns) gemspec attributes. These options take any gemspec attribute and more than one when comma delimited. Gemspec attributes can be aliased by specifying the first unique string that it starts with i.e. "su" for "summary".'
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = 'tagaholic'
  s.add_dependency 'hirb'
  s.files = Dir.glob(%w[{lib,test}/**/*.rb bin/* [A-Z]*.{txt,rdoc} ext/**/*.{rb,c} **/deps.rip]) + %w{Rakefile .gemspec}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt"]
  s.license = 'MIT'
end