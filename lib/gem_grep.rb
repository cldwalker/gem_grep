current_dir = File.dirname(__FILE__)
$:.unshift(current_dir) unless $:.include?(current_dir) || $:.include?(File.expand_path(current_dir))
require 'rubygems/super_search'

module GemGrep
  extend self
  attr_accessor :grep_fields, :display_fields
  def grep_fields
    @grep_fields ||= ['name']
  end

  def display_fields
    @display_fields ||= [:name,:summary,:authors]
  end

  def valid_gemspec_columns
    @valid_gemspec_columns ||= Gem::Specification.attribute_names.map {|e| e.to_s}.sort
  end

  def parse_input(input)
    input.split(/\s*,\s*/).map {|e|
      valid_gemspec_columns.detect {|c| c =~ /^#{e}/ }
    }.compact
  end
end
