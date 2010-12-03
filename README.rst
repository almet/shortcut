shortcut
########

`Shortcut` is a tiny utility to manage bookmarks for your shell.

It provides a simple command line to do all you want to do with your
bookmarks::

Install shorcut
===============

You can rely on the `gem` systems to install shorcut::

    $ gem install shortcut

And that's it !

How to use shorcut
==================

`--create` will create or update a bookmark with the name `name`, pointing to 
the current directory.::

    $ shortcut --create name

You can also specify the path you want the bookmarks points to::

    $ shortcut --create name /path/to/your/folder

`shortcut name` will move to the path indicated by `name`::

    $ shortcut name
    $ pwd
    /path/to/your/folder

You can also list all the existing bookmarks::

    $ shortcut --list
    name → /path/to/your/folder

And remove some if you want to::

    $ shortcut --remove name
    $ shortcut --clear
