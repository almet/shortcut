require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pp'

class ShortcutOptions

  def self.parse(args)
    action = 'cd' # default action is to change the directory (cd)

    opts = OptionParser.new do |opts|
      opts.banner = "Usage: example.rb [options]"

      opts.separator ""
      opts.separator "Specific action"

      opts.on("-c", "--create", "Create the given bookmark") do |create|
        action = "create"
      end

      opts.on("-d", "--delete", "Delete the given bookmark") do |delete|
          action = "delete"
      end

      opts.on("-l", "--list", "List all the existing bookmarks") do |list|
          action = "list"
      end

      opts.separator ""
      opts.separator "Common action"

      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end

    opts.parse!(args)
    action
  end  # parse()
end  # class

action = ShortcutOptions.parse(ARGV)

case action
when "create"
    puts "create"
when "list"
    puts "loliste"
end
