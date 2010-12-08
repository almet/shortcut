require 'backends.rb'

# define some exceptions to be used
class ShortcutError < StandardError; end # the base exception class for this lib
class ShortcutExists < ShortcutError; end
class ShortcutsDoesNotExists < ShortcutError; end
class NotADirectory < ShortcutError; end

class Shortcut
    def initialize(backend=nil)
        backend ||= SqliteBackend.new
        @backend = backend
        @shortcuts = @backend.read()
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

    def has?(name)
        return @shortcuts.has_key? name
    end

    def persist
        @backend.write(@shortcuts)
    end

    def each
        @backend.each do |key, value|
            yield key, value
        end
    end
end
