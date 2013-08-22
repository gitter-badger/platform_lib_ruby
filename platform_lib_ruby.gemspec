# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'platform_lib/version'

Gem::Specification.new do |spec|
  spec.name          = "platform_lib"
  spec.version       = PlatformLib::VERSION
  spec.authors       = ["David Muto"]
  spec.email         = ["david.muto@gmail.com"]
  spec.description   = %q{Simple library for working with ThePlatform Data Services}
  spec.summary       = %q{Work with ThePlatform Data Services}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "json"
  spec.add_dependency "hashie"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "tomdoc"
end
