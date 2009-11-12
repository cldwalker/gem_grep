require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
begin
  require 'rcov/rcovtask'

  Rcov::RcovTask.new do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/*_test.rb']
    t.rcov_opts = ["-T -x '/Library/Ruby/*'"]
    t.verbose = true
  end
rescue LoadError
  puts "Rcov not available. Install it for rcov-related tasks with: sudo gem install rcov"
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "gem_grep"
    s.description = 'Enhances search command by displaying results in an ascii table and providing options to search (--fields) and display (--columns) gemspec attributes. These options take any gemspec attribute and more than one when comma delimited. Gemspec attributes can be aliased by specifying the first unique string that it starts with i.e. "su" for "summary".'
    s.summary = "A gem command plugin which enhances the search command by providing extra search options and displaying results as a table."
    s.email = "gabriel.horner@gmail.com"
    s.homepage = "http://github.com/cldwalker/gem_grep"
    s.authors = ["Gabriel Horner"]
    s.has_rdoc = true
    s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt"]
    s.files = FileList["[A-Z]*", "{bin,lib,test}/**/*"]
    s.add_dependency 'hirb'
    s.rubyforge_project = 'tagaholic'
  end

rescue LoadError
  puts "Jeweler not available. Install it for jeweler-related tasks with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'test'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => :test
