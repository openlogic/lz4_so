lz4_so
======

Build lz4 as shared object files and package for Linux distros.

Notes
=====

This Makefile was created to build .deb files for installing lz4 shared
objects on Ubuntu.  After looking around extensively, no one was
packaging lz4 for inclusion in Ubuntu or any other Linux system and we
had a desire to enable lz4 compression for Hadoop and HBase.

The original Makefile that did the shared object compile comes from a
dependency in the lumberjack project.

Requirements
============
subversion - to get the lz4 source
make - to build the files
ruby - for package creation
rubygems - for package creation
fpm - for package creation

Usage
=====

Edit the REVISION variable in the makefile if you want a different
version than revision 88 (the latest at the time I created this).

- make install
- gem install fpm
- make deb

make will use subversion to export the source code from the original
repository, build the .so files, move them into the correct directory
structure, and then create liblz4 and liblz4-dev packages.


Notes
=====

lz4 source  http://code.google.com/p/lz4/
fpm - https://github.com/jordansissel/fpm
lumberjack - https://github.com/jordansissel/lumberjack/tree/master/vendor/lz4

