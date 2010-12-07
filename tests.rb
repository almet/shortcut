require "test/unit"
require "shortcut.rb"
require "backends.rb"
require "rubygems"
require "mocha"

class ShortcutTest < Test::Unit::TestCase
    def test_initialize
        # test that the default behavior is to create a new SQLite backend
        sh = Shortcut.new()
        assert_instance_of(SqliteBackend, sh.instance_eval{@backend})
        # test that it is possible to pass another backend
        # test that the backend is read at this stage, and it fills internal
        # @shortcuts with the result
        backend = mock()
        backend.expects(:read => :test)
        sh = Shortcut.new(backend)
        assert_equal(backend, sh.instance_eval{@backend})
        assert_equal(:test, sh.instance_eval{@shortcuts})
    end

    def test_create
        # if the path is nil, default to current dir
        backend = mock(:read => {})
        sh = Shortcut.new(backend)
        sh.create('foo')
        assert_equal({'foo'=> Dir.pwd}, sh.instance_eval{@shortcuts})
        # if the name already exists, and overwrite is not true, then raise an
        # exception
        assert_raises ShortcutExists do
            sh.create('foo')
        end

        # check that the path is an existing directory, or raise an exception
        assert_raises NotADirectory do
            sh.create('foobar', '/does/not/exists')
        end
        # create the new value in the hash and return it
        sh.create('foo', Dir.pwd, true)
        assert_equal({'foo'=> Dir.pwd}, sh.instance_eval{@shortcuts})
    end

    def test_delete
        backend = mock(:read => {"foo" => "bar"})
        sh = Shortcut.new(backend)
        # just call delete
        sh.delete("foo")
        assert_equal({}, sh.instance_eval{@shortcuts})
    end

    def test_list
        # test that the returned list is freezed
        backend = mock(:read => {"foo" => "bar"})
        sh = Shortcut.new(backend)
        assert(sh.list.frozen?)
    end

    def test_get
        # test that it returns the right element
        backend = mock(:read => {"foo" => "bar"})
        sh = Shortcut.new(backend)
        assert_equal(sh.get("foo"), "bar")
        # test that if it does not exists, it raises an exception
        assert_raises ShortcutsDoesNotExists do
            sh.get("unexisting")
        end
    end

    def test_persist
        # test that the method write of the backend is well called
        backend = mock(:read => :foo)
        backend.expects(:write).with(:foo)
        sh = Shortcut.new(backend)
        sh.persist()
    end
end

class SQLiteBackendTest < Test::Unit::TestCase
    def teardown
        begin
            File.delete("tests.db")
        rescue
        end
    end

    def test_create_if_new
        assert !File.exists?("tests.db") # the file does not exists
        backend = SqliteBackend.new('tests.db')
        assert File.exists?("tests.db") # the file exists
    end

    def test_write_read
        backend = SqliteBackend.new("tests.db")
        backend.write({'foo' => 'bar', 'baz' => 'foobaz'})
        assert_equal(backend.read(), {'foo' => 'bar', 'baz' => 'foobaz'})
    end
end
