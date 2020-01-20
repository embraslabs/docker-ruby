require 'terminal-table'

def query(sql)
  ActiveRecord::Base.connection.exec_query(sql).map(&:to_h)
end

def query_columns(sql)
  ActiveRecord::Base.connection.select_all(sql)
end

def table(sql)
  result = query_columns(sql)

  table = Terminal::Table.new title: 'Table query', headings: result.columns, rows: result.rows
  table.add_row :separator
  table.add_row [{ value: "Record count #{result.rows.length}", colspan: result.columns.length }]

  puts table
end

def environment
  return "** #{ENV['RAILS_ENV'].upcase} **".red if Rails.env.production?

  ENV['RAILS_ENV'].yellow
end

def adapter
  "#{ENV['DATABASE_ADAPTER']}@#{ENV['DATABASE_NAME']}".yellow
end

def console_info(obj, nest_level, separator)
  return "\e[1;32mRuby #{RUBY_VERSION} in #{environment} \e[1;35mwith #{adapter}\e[36m (scope #{obj}) \n#{separator} \e[0m" if nest_level.zero?

  "\e[1;32mRuby #{RUBY_VERSION} in #{environment} \e[1;35mwith #{adapter}\e[36m (scope #{obj}) at level #{nest_level}\n#{separator} \e[0m"
end

Pry.editor = ENV['EDITOR'] || 'vi'

Pry::Prompt.add(
  :labs,
  'Prompt da embraslabs',
  ['>', '*']
  ) do |obj, nest_level, _, separator|
  separator == '>' ? console_info(obj, nest_level, separator) : '*'
end

Pry.prompt = Pry::Prompt[:labs]
Pry.config.ls.separator = "\n"
Pry.config.ls.heading_color = :magenta
Pry.config.ls.public_method_color = :green
Pry.config.ls.protected_method_color = :yellow
Pry.config.ls.private_method_color = :bright_black

Pry.config.exception_handler = proc do |output, exception, _|
  output.puts "\e[31m#{exception.class}: #{exception.message}"
  output.puts "from #{exception.backtrace.first}\e[0m"
end

if defined?(Rails::ConsoleMethods)
  include Rails::ConsoleMethods
else
  def reload!(print = true)
    puts 'Reloading...' if print
    ActionDispatch::Reloader.cleanup!
    ActionDispatch::Reloader.prepare!
    true
  end
end

Pry.config.print = proc do |output, value|
  Pry::Helpers::BaseHelpers
  .stagger_output("\n=> #{Pry::Helpers::BaseHelpers.colorize_code(Pry::Helpers::Text.strip_color(value.ai))} \n", output)
end

Pry.commands.alias_command 'h', 'hist -T 20', desc: 'Last 20 commands'
Pry.commands.alias_command 'hg', 'hist -T 20 -G', desc: 'Up to 20 commands matching expression'
Pry.commands.alias_command 'hG', 'hist -G', desc: 'Commands matching expression ever used'
Pry.commands.alias_command 'hr', 'hist -r', desc: 'hist -r <command number> to run a command'
Pry.commands.alias_command 'cls', 'clear-screen', desc: 'clear screen'

Pry.commands.alias_command 'w', 'whereami'
Pry.commands.alias_command 's', 'step'
Pry.commands.alias_command 'n', 'next'
Pry.commands.alias_command 'c', 'continue'
Pry.commands.alias_command 'f', 'finish'
Pry.commands.alias_command 'ex', 'exit-program'

Pry.commands.alias_command 'ff', 'frame'
Pry.commands.alias_command 'u', 'up'
Pry.commands.alias_command 'd', 'down'
Pry.commands.alias_command 'b', 'break'

puts Terminal::Table.new title: "\e[1;33mQuery\e[0m", headings: %w[Command Explanation], rows: [
  ['query(sql)', 'Run any valid query and return array of objects'],
  ['query_columns(sql)', 'Run any valid query and return the object that contains columns and rows'],
  ['table(sql)', 'Run any valid query and show the data in a table']
], style: { width: 100 }

puts Terminal::Table.new title: "\e[1;33mDebugging Shortcuts\e[0m", headings: %w[Shortcut Command], rows: [
  %w[w whereami],
  %w[s step],
  %w[n next],
  %w[c continue],
  %w[f finish],
  %w[ex exit-program]
], style: { width: 40 }

puts Terminal::Table.new title: "\e[1;33mStack movement\e[0m", headings: %w[Shortcut Command], rows: [
  %w[ff frame],
  %w[u up],
  %w[d down],
  %w[b break]
], style: { width: 40 }
