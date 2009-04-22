require 'rubygems/command_manager'
require 'rubygems/commands/query_command'
require 'rubygems/super_search'
require 'hirb'

Gem::CommandManager.instance.register_command :grep