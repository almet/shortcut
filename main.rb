require 'optparse'
require 'shortcut.rb'

# this is from the newest version of ruby. and is GPLv2'd
# you can find more informations on
# http://svn.ruby-lang.org/repos/ruby/trunk/lib/shellwords.rb
def shellescape(str)
   # An empty argument will be skipped, so return empty quotes.
   return "''" if str.empty?
   str = str.dup
   str.gsub!(/([^A-Za-z0-9_\-.,:\/@\n])/n, "\\\\\\1")
   str.gsub!(/\n/, "'\n'")
   return str
end

# parse the options and return the action and if it's needed to overwrite
def parse_opts
    # Default parameter values
    action = 'cd'
    overwrite = false

    opts = OptionParser.new do |opts|
        opts.banner = "Usage: to [options]"

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
    return action, overwrite
end

# because it's not possible tan change the directory of a parent process, I'm
# using here some hacks, using bash.
# What I do, is looking at what's returned by the library, and transform it to
# code that is executable by the shell.
# Later on, while calling the script, I'm transforming it to something
# executable (e.g. $(myrubyscript)) using an alias
def call_shortcut(action, overwrite, args)
    sc = Shortcut.new()
    case action

    when 'list'
        string = ""
        sc.list().each do |key, value|
            string += "\n\t#{key}\t#{value}"
        end
        puts string

    when 'cd'
        if args.empty?
            puts "you need to provide a name for the shortcut you want to use"
        else
            begin
                path = sc.get(args[0])
                puts "cd #{path}"
            rescue BookmarksDoesNotExists => e
                puts "sorry, unable to get a bookmark for '#{e.message}'"
            end
        end

    when 'create'
        if args.empty?
            puts "you need to provide a name for the shortcut you want to create"
        else
            begin
                name, path = args[0], args[1]
                path = sc.create(name, path, overwrite)
                puts "added an alias #{name} to #{path}"
            rescue BookmarkExists => e
                puts "this shortcut already points to #{e.message}"
            rescue NotADirectory => e
                puts "#{e.message} is not a directory"
            end
        end

    when 'delete'
        if args.empty?
            puts "you need to provide the name of the shortcut you want to delete"
        else
            begin
                sc.delete(args[0])
                puts "ok"
            rescue BookmarksDoesNotExists => e
                puts "sorry, unable to find a bookmark for '#{e.message}'"
            end
        end
    end

    sc.persist() #finally, persists the changes
end
action, overwrite = parse_opts()
call_shortcut(action, overwrite, ARGV)

