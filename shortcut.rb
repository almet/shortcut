require 'sqlite3'

# define some exceptions to be used
class ShortcutError < StandardError; end # the base exception class for this lib
class ShortcutExists < ShortcutError; end
class ShortcutsDoesNotExists < ShortcutError; end
class NotADirectory < ShortcutError; end

# backends
class FakeBackend
    def read
        # load file
        return {"dev" => "/home/alexis/dev/"}
    end

    def write(shortcuts)
        puts "writing files"
    end
end

class SqliteBackend

    def initialize(file=nil)
        file ||= "shortcuts.db"
        @file = file
        @db = SQLite3::Database.new(@file)
        if not File.exists?(@file)
            self.create_tables
        end
        @hash = {}
    end

    def read
        @db.execute("SELECT name, path FROM shortcuts;").each do |name, path|
            @hash[name] = path
        end
        return @hash.clone
    end
    
    def write(shortcuts)
        # check the differences between the old and the new hash and
        # insert/delete when needed. No modification is allowed for now, just
        # add/delete
        shortcuts.each do |key, value|
            if @hash.has_key? key and @hash[key] != value
                self.update(key, value)
            elsif not @hash.has_key? key
                self.create(key, value)
            end
        end

        @hash.each do |key, value|
            if not shortcuts.has_key? key
                self.delete(key)
            end
        end
    end

    protected # all methods folowing that will be protected

    def create_tables()
        @db.execute("DROP TABLE IF EXISTS shortcuts;")
        @db.execute("CREATE TABLE shortcuts (name varchar(100), path text);")
    end

    def create(name, path)
        @db.execute("INSERT INTO shortcuts VALUES (\"#{name}\", \"#{path}\");")
    end

    def delete(name)
        @db.execute("DELETE FROM shortcuts WHERE name = \"#{name}\";")
    end

    def update(name, path)
        @db.execute("UPDATE shortcuts SET path=\"#{path}\" where name=\"#{name}\";")
    end
end

class Shortcut
    def initialize(backend=nil)
        backend ||= SqliteBackend.new
        @backend = backend
        @shortcuts = @backend.read()

        # in case the gc collects
        ObjectSpace.define_finalizer(self, proc {self.persists})
    end

    def create(name, path=nil, overwrite=false)
        path ||= Dir.getwd

        # check that the directory exists
        if not(File.exists?(path) && File.directory?(path))
           raise NotADirectory, path
        end

        if @shortcuts.has_key? name and not overwrite
            raise ShortcutExists, @shortcuts[name]
        end
        @shortcuts[name] = path
        return path
    end

    def delete(name)
        return @shortcuts.delete(name)
    end

    def list()
        return @shortcuts.freeze
    end

    def get(name)
        if @shortcuts.has_key? name
            return @shortcuts[name]
        else
            raise ShortcutsDoesNotExists, name
        end
    end

    def persist
        @backend.write(@shortcuts)         
    end
end
