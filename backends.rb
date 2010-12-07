
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
        require 'sqlite3'
        file ||= "shortcuts.db"
        @file = file
        if not File.exists?(@file)
            @db = SQLite3::Database.new(@file)
            self.create_tables
        else
            @db = SQLite3::Database.new(@file)
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
        # insert/delete when needed.
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

class RedisBackend
    def initialize(host=nil, port=nil)
        require 'rubygems'
        require 'redis'
        require 'json'
        @server = Redis.new(:host => host, :port => port)
    end

    def read
        shortcuts = @server.get "shortcuts"
        if shortcuts != nil
            shortcuts = JSON.load(shortcuts)
        end
        shortcuts ||= {}
        return shortcuts
    end

    def write(shortcuts)
        @server.set "shortcuts", shortcuts.to_json
    end

end
