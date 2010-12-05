require 'optparse'
require 'shortcut.rb'

# Default parameter values
action = 'cd' 
overwrite = false

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

    opts.on("-o", "--overwrite", "Overwrite shortcut if exists") do
        overwrite = true
    end
  
    opts.separator ""
    opts.separator "Common action"
  
    opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
    end
end.parse! # this one is required to actually parse the options.

args = ARGV

sc = Shortcut.new()

# because it's not possible tan change the directory of a parent process, I'm
# using here some hacks, using bash.
# What I do, is looking at what's returned by the library, and transform it to
# code that is executable by the shell.
# Later on, while calling the script, I'm transforming it to something
# executable (e.g. $(myrubyscript)) using an alias
case action

when 'list'
    string = "echo "
    sc.list().each do |key, value|
        string += "#{key}\\t #{value}"
    end
    puts string

when 'cd' 
    if args.empty?
        puts "echo you need to provide a name for the shortcut you want to use"
    else
        begin
            path = sc.get(args[0]) 
            puts "cd #{path}"
        rescue BookmarksDoesNotExists => e
            puts "echo sorry, unable to get a bookmark for '#{e.message}'"
        end
    end

when 'create'
    if args.empty?
        puts "echo you need to provide a name for the shortcut you want to create"
    else
        begin
            name, path = args[0], args[1]
            path = sc.create(name, path, overwrite)
            puts "echo added an alias #{name} to #{path}"
        rescue BookmarkExists => e
            puts "echo this shortcut already points to #{e.message}"
        rescue NotADirectory => e
            puts "echo #{e.message} is not a directory"
        end
    end

when 'delete'
    if args.empty?
        puts "echo you need to provide the name of the shortcut you want to delete"
    else
        begin
            sc.delete(args[0])
            puts "echo ok"
        rescue BookmarksDoesNotExists => e
            puts "echo sorry, unable to find a bookmark for '#{e.message}'"
        end
    end
end

sc.persist #finally, persists the changes
