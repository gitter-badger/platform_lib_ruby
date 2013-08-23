# Platform Lib Ruby 

[![Build Status](https://travis-ci.org/ShawONEX/platform_lib_ruby.png)](https://travis-ci.org/ShawONEX/platform_lib_ruby)

A simple gem to help us work with ThePlatform's Data Service API.

## Installation

Add this line to your application's Gemfile:

    gem 'platform_lib_ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install platform_lib_ruby

## Usage

The gem will add `tp_lib` to your PATH. This command executes scripts found in 
the scripts directory.

Currently there is only one script. Here's how we use it:

    $ tp_lib sync_guid_with_id <user> <pass>

*Replace <user> and <pass> with your MPX username and password*

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
