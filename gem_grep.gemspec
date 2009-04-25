# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gem_grep}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gabriel Horner"]
  s.date = %q{2009-04-25}
  s.description = %q{Enhances search command by displaying results in an ascii table and providing options to search (--fields) and display (--columns) gemspec attributes. These options take any gemspec attribute and more than one when comma delimited. Gemspec attributes can be aliased by specifying the first unique string that it starts with i.e. "su" for "summary".}
  s.email = %q{gabriel.horner@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION.yml",
    "lib/rubygems/commands/grep_command.rb",
    "lib/rubygems/super_search.rb",
    "lib/rubygems_plugin.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/cldwalker/gem_grep}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{tagaholic}
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{A gem command plugin which enhances the search command by providing extra search options and displaying results as a table.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cldwalker-hirb>, [">= 0"])
    else
      s.add_dependency(%q<cldwalker-hirb>, [">= 0"])
    end
  else
    s.add_dependency(%q<cldwalker-hirb>, [">= 0"])
  end
end
