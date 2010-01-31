require 'rubygems/commands/query_command'
require 'rubygems/super_search'
require 'hirb'
require 'gem_grep'

class Gem::Commands::GrepCommand < Gem::Commands::QueryCommand
  attr_accessor :results, :results_only
  def initialize
    super 'grep', "Enhances search command by providing extra search options and displaying results as a table"
    defaults.merge!(:columns=>[:name,:summary,:authors])

    add_option('-c', '--columns STRING', 'Gemspec columns/attributes to display per gem') do |value, options|
      options[:columns] = GemGrep.parse_input(value).map {|e| e.to_sym}
    end

    add_option('-f', '--fields STRING', 'Gemspec fields/attributes to search (only for local gems)') do |value, options|
      GemGrep.grep_fields = options[:fields] = GemGrep.parse_input(value)
    end
    remove_option '--name-matches'
    remove_option '-d'
    remove_option '--versions'
  end

  def arguments # :nodoc:
    "REGEXP          regular expression string to search specified gemspec attributes"
  end

  def usage # :nodoc:
    "#{program_name} [REGEXP]"
  end

  def defaults_str # :nodoc:
    "--local --columns name,summary,authors --fields name --no-installed"
  end
  
  def description # :nodoc:
    'Enhances search command by providing options to search (--fields) and display (--columns) ' +
   'gemspec attributes. Results are displayed in an ascii table. Gemspec attributes can be specified '+
   'by the first unique string that it starts with i.e. "su" for "summary". To specify multiple gemspec attributes, delimit ' +
   "them with commas. Gemspec attributes available to options are: #{GemGrep.valid_gemspec_columns.join(', ')}."
  end
  
  def execute
    string = get_one_optional_argument
    options[:name] = /#{string}/i
    Gem.source_index.extend Gem::SuperSearch
    super
  end
  
  def output_query_results(tuples)
    @results = cleanup_tuples(tuples).map {|e| e[0][-1]}
    @results_only ? @results :
      say(Hirb::Helpers::Table.render(@results, :fields=>options[:columns]))
  end
  
  # borrowed from query command
  def cleanup_tuples(spec_tuples)
    versions = Hash.new { |h,name| h[name] = [] }

    spec_tuples.each do |spec_tuple, source_uri|
      versions[spec_tuple.first] << [spec_tuple, source_uri]
    end

    versions = versions.sort_by do |(name,_),_|
      name.downcase
    end
    tuples = options[:all] ? versions.inject([]) {|t,e| t += e[1]; t } : versions.map {|e| e[1].first }
    tuples.each {|e|
      if e.first.length != 4
       uri = URI.parse e.last
       spec = Gem::SpecFetcher.fetcher.fetch_spec e.first, uri
       e.first.push(spec)
      end
    }
    tuples
  end
end