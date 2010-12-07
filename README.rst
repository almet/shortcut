shortcut
########

`Shortcut` is a tiny utility to manage bookmarks for your shell.

It provides a simple command line to do all you want to do with your
bookmarks: `to`.

Install shorcut
===============

From gems
---------

You can rely on the `gem` systems to install shorcut::

    $ gem install shortcut

Then, you will need to source a special file in you .bashrc, .zshrc or
whatever, that will be read at the beginning of your shell session.

From sources
------------

You can also choose to install shortcut from sources::

    $ git clone https://ametaireau@github.com/ametaireau/shortcut.git
    $ ???

How to use shorcut
==================

Shortcut is really simple. Say you want to go to a particular path, for which
you have already created an shortcut::

    $ to foobar
    sorry, unable to get a shortcut for 'foobar'

Obviously, that's because you need to create the bookmark::

    $ to --create foobar

`--create` will create or update a bookmark with the name `name`, pointing to 
the current directory.  
You can also specify the path you want the bookmarks points to::

    $ to --create foobaz /path/to/your/folder
    added an alias foobaz to /path/to/your/folder

If you want to overwrite an already existing bookmark, you can use the
`--overwrite` option::

    $ to --create foobar /path/to/your/folder --overwrite
    added an alias foobar to /path/to/your/folder

You can also list all the existing bookmarks::

    $ to --list
        
        foobar     /path/to/your/folder
        foobaz     /path/to/your/folder

And remove some if you want to::

    $ to --remove foobar
    ok

By default, the backend is a SQLite database, but you can use a Redis server if
you want (once again, it was just for the sake of implementing a redis backend,
that's doesnt sound very useful :))::

    $ to --redis 

Dependencies
============

`Shortcut` have dependencies to `Redis` and `SQLite3`, depending on the backend
you want to use. `Redis` also need the `SystemTimer` gem to be installed.

Notes
=====

This software have been made to learn ruby. So it's far from perfect and not
really made to be usable. I mean by that that here I'm using a sqlite database
to store bookmarks. I found that's a bit overkill. Still, I'd learned how to
query sqlite databases ! So the point is not to make something really useful,
but to learn how those are working :)

Don't hesitate to provide me any feedback if you want to, I'll be happy to
learn what I've made wrong.
