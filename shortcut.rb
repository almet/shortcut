class BookmarkExists < StandardError
end

class Shortcut
    def initialize()
        @bookmarks = {}

    def self.create(name, path=nil, overwrite=false)
        path ||= "TEST"
        if @bookmarks.has_key? name and not overwrite
            raise BookmarkExists("{#bookmarks[name]}")
        @bookmarks[name] = path

    def self.remove(name)
        puts @bookmarks[name]
    end

    def self.list()
        return @bookmarks.freeze
    end

    def finalize()
        puts "test"
    end
