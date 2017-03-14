# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'efo_nelfo/version'

Gem::Specification.new do |spec|
  spec.name          = "efo_nelfo"
  spec.version       = EfoNelfo::VERSION
  spec.authors       = ["Gudleik Rasch"]
  spec.email         = ["gr@skalar.no"]
  spec.description   = %q{Parser for EFONELFO format}
  spec.summary       = %q{Parser for EFONELFO format}
  spec.homepage      = "http://efo.no"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.2.5"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "awesome_print", "~> 1.7"
  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-minitest", "~> 2.4"
  spec.add_development_dependency "minitest", "~> 5.10"
  spec.add_development_dependency "minitest-reporters", "~> 1.1"
  spec.add_development_dependency "rb-fsevent", "~> 0.9"
  spec.add_development_dependency "terminal-notifier", "~> 1.7"
  spec.add_development_dependency "terminal-notifier-guard", "~> 1.7"
  spec.add_development_dependency "simplecov", "~> 0.13"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 1.0"
end
