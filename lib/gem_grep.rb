current_dir = File.dirname(__FILE__)
$:.unshift(current_dir) unless $:.include?(current_dir) || $:.include?(File.expand_path(current_dir))
require 'rubygems/super_search'
require 'zlib'
require 'fileutils'

module GemGrep
  extend self
  attr_accessor :grep_fields, :display_fields
  def grep_fields
    @grep_fields ||= ['name', 'description', 'summary']
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

  class Index
    attr_accessor :server
    def initialize(server)
      @server = server
      setup_marshal_index unless File.exists?(marshal_file)
    end

    def gem_server
      {:rubyforge=>"http://gems.rubyforge.org", :github=>"http://gems.github.com"}
    end

    def gem_index
      @gem_index ||= begin
        puts "Loading large gem index. Patience is a bitch ..."
        temp_index = Marshal.load(File.read(marshal_file))
        temp_index.extend(Gem::SuperSearch)
      end
    end

    def setup_marshal_index(name=nil)
      server = name if name
      download_marshal_index unless File.exists?(marshal_compressed_file)
      File.open(marshal_file, 'w') {|f| f.write Zlib::Inflate.inflate(File.read(marshal_compressed_file)) }
    end

    def download_marshal_index
      puts "Downloading compressed Marshal gemspec index to ~/.gem_grep. Patience is a bitch..."
      FileUtils.mkdir_p("~/.gem_grep")
      system("curl #{marshal_url} > #{marshal_compressed_file}")
    end

    def marshal_file
      File.expand_path "~/.gem_grep/marshal_#{server}"
    end

    def marshal_compressed_file
      File.expand_path "~/.gem_grep/marshal_#{server}.Z"
    end

    def marshal_url
      gem_server[server] + "/Marshal.#{Marshal::MAJOR_VERSION}.#{Marshal::MINOR_VERSION}.Z"
    end
  end
end
