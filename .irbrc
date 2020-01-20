$: << '/.gems/gems/terminal-table-3.0.0/lib/'
$: << '/.gems/gems/unicode-display_width-1.7.0/lib/'

require 'terminal-table'
require "awesome_print"

AwesomePrint.irb!

if defined?(Rails::Console)

  header = ['Dependency', 'Status']
  rows = []
  rows << ['Terminal Table', defined?(Terminal::Table) == "constant" ? "Loaded" : "Not Loaded"]
  rows << ['AwesomePrint', defined?(AwesomePrint) == "constant" ? "Loaded" : "Not Loaded"]
  rows << ['Pry', defined?(Pry) == "constant" ? "Loaded" : "Not Loaded"]

  table = Terminal::Table.new headings: header, rows: rows
  puts table

  begin
    require "pry"
    Pry.start
    exit
  rescue LoadError => e
    warn "=> Unable to load pry"
  end
end
