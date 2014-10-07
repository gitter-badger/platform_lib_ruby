# Platform Lib Ruby 
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/ShawONEX/platform_lib_ruby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://travis-ci.org/ShawONEX/platform_lib_ruby.png)](https://travis-ci.org/ShawONEX/platform_lib_ruby)
[![Gem Version](https://badge.fury.io/rb/platform_lib.svg)](http://badge.fury.io/rb/platform_lib)


A simple gem to help us work with ThePlatform's Data Service API.

## Installation

You'll need to clone the repo and cd into the directory. Then run these:

    $ bundle install
    $ rake install

Add this line to your application's Gemfile (if writing code):

    gem 'platform_lib'

## Updating

Navigate to the working directory, and run the following:

    $ gem uninstall platform_lib
    $ git pull
    $ bundle install
    $ rake install

## Usage

The gem will add `tp_lib` to your PATH. This command executes scripts found in 
the scripts directory.

Currently there is only one script. Here's how we use it:

    $ tp_lib sync_guid_with_id <user> <pass>

*Replace `<user>` and `<pass>` with your MPX username and password*

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
