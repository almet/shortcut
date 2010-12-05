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

Notes
=====

This software have been made to learn ruby. So it's far from perfect and not
really made to be usable. I mean by that that here I'm using a sqlite database
to store bookmarks. I found that's a bit overkill. Still, I'd learned how to
query sqlite databases ! So the point is not to make something really useful,
but to learn how those are working :)

Don't hesitate to provide me any feedback if you want to, I'll be happy to
learn what I've made wrong.
