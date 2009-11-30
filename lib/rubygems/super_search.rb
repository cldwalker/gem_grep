# Extends Gem::SourceIndex#search to allow searching of any gemspec attribute field.
# Differs from original method (from rubygems v1.3.2) by a couple of lines.
module Gem::SuperSearch
  def search(gem_pattern, platform_only = false)
    version_requirement = nil
    only_platform = false

    # TODO - Remove support and warning for legacy arguments after 2008/11
    unless Gem::Dependency === gem_pattern
      warn "#{Gem.location_of_caller.join ':'}:Warning: Gem::SourceIndex#search support for #{gem_pattern.class} patterns is deprecated"
    end

    case gem_pattern
    when Regexp then
      version_requirement = platform_only || Gem::Requirement.default
    when Gem::Dependency then
      only_platform = platform_only
      version_requirement = gem_pattern.version_requirements
      gem_pattern = if Regexp === gem_pattern.name then
                      gem_pattern.name
                    elsif gem_pattern.name.empty? then
                      //
                    else
                      /^#{Regexp.escape gem_pattern.name}$/
                    end
    else
      version_requirement = platform_only || Gem::Requirement.default
      gem_pattern = /#{gem_pattern}/i
    end

    unless Gem::Requirement === version_requirement then
      version_requirement = Gem::Requirement.create version_requirement
    end
    
    # only changes from original method
    # search_fields = Gem::CommandManager.instance['grep'].options[:fields] || ['name']
    search_fields = GemGrep.grep_fields
    specs = all_gems.values.select do |spec|
      search_fields.map {|e| spec.send(e).to_s}.any? {|e| e =~ gem_pattern} and
        version_requirement.satisfied_by? spec.version
    end

    if only_platform then
      specs = specs.select do |spec|
        Gem::Platform.match spec.platform
      end
    end

    specs.sort_by { |s| s.sort_obj }
  end
end
