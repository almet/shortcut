require 'sqlite3'

# define some exceptions to be used
class ShortcutError < StandardError; end # the base exception class for this lib
class BookmarkExists < ShortcutError; end
class BookmarksDoesNotExists < ShortcutError; end
class NotADirectory < ShortcutError; end

class FakeBackend
    def read
        # load file
        return {"dev" => "/home/alexis/dev/"}
    end

    def write(bookmarks)
        puts "writing files"
    end
end

# backends
class SqliteBackend
    def initialize(file=nil)
        file ||= "shortcuts.db"
        @file = file
        @db = SQLite3::Database.new(file)
        @map = {}
    end

    def create_tables()
        @db.execute("DROP TABLE IF EXISTS shortcuts;")
        @db.execute("CREATE TABLE shortcuts (name varchar(100), path text);")
    end

    def read
        if not(File.exists?(@file) && File.directory?(@file))
            self.create_tables()
        end
        @db.execute("SELECT * FROM shortcuts") do |row| 
            @map[key] = value
        end
        return @map
    end
    
    def add(name, path)
        @db.execute("INSERT INTO shortcuts VALUES (\"#{name}\", \"#{value}\");")
    end

    def remove(name)
        @db.execute("DELETE FROM shortcuts WHERE name = \"#{name}\";")
    end

    def update(name, path)
        @db.execute("UPDATE shortcuts SET path=\"#{path}\" where name=\"#{name}\"";)
    end

    def write(bookmarks)
        # check the differences between the old and the new map and
        # insert/delete when needed. No modification is allowed for now, just
        # add/delete
        bookmarks.each do |key, value|
            if @map.has_key? key and 
        
        end
        puts "writing files"
    end
end

class Shortcut
    def initialize(backend=nil)
        backend ||= SqliteBackend.new
        @backend = backend
        @bookmarks = @backend.read()

        # in case the gc collects
        ObjectSpace.define_finalizer(self, proc {self.persists})
    end

    def create(name, path=nil, overwrite=false)
        path ||= Dir.getwd

        # check that the directory exists
        if not(File.exists?(path) && File.directory?(path))
           raise NotADirectory, path
        end

        if overwrite
            puts "overwrite"
        end
        if @bookmarks.has_key? name and not overwrite
            raise BookmarkExists, @bookmarks[name]
        end
        @bookmarks[name] = path
        return path
    end

    def delete(name)
        return @bookmarks.delete(name)
    end

    def list()
        return @bookmarks.freeze
    end

    def get(name)
        if @bookmarks.has_key? name
            return @bookmarks[name]
        else
            raise BookmarksDoesNotExists, name
        end
    end

    def persist
        @backend.write(@bookmarks)         
    end
end
