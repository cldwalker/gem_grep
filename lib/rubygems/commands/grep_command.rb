require 'rubygems/commands/query_command'
require 'rubygems/super_search'
require 'hirb'

class Gem::Commands::GrepCommand < Gem::Commands::QueryCommand
  class<<self
    def valid_gemspec_columns
      @valid_gemspec_columns ||= Gem::Specification.attribute_names.map {|e| e.to_s}.sort
    end
  end

  def initialize
    super 'grep', "Enhances search command by providing extra search options and displaying results as a table"
    defaults.merge!(:columns=>[:name,:summary,:authors])

    add_option('-c', '--columns STRING', 'Gemspec columns/attributes to display per gem') do |value, options|
      options[:columns] = value.split(/\s*,\s*/).map {|e|
        self.class.valid_gemspec_columns.detect {|c| c =~ /^#{e}/ }
      }.compact.map {|e| e.to_sym}
    end

    add_option('-f', '--fields STRING', 'Gemspec fields/attributes to search (only for local gems)') do |value, options|
      options[:fields] = value.split(/\s*,\s*/).map {|e|
        self.class.valid_gemspec_columns.detect {|c| c =~ /^#{e}/ }
      }.compact
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
   "them with commas. Gemspec attributes available to options are: #{self.class.valid_gemspec_columns.join(', ')}."
  end
  
  def execute
    string = get_one_optional_argument
    options[:name] = /#{string}/i
    Gem.source_index.extend Gem::SuperSearch
    super
  end
  
  def output_query_results(tuples)
    tuples = cleanup_tuples(tuples)
    records = tuples.map {|e|
      options[:columns].inject({:name=>e[0][0]}) {|h,c|
        val = e[0][-1].send(c)
        h[c] = val.is_a?(Array) ? val.join(',') : val; h 
      }
    }
    say Hirb::Helpers::Table.render(records, :fields=>options[:columns])
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