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

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "rb-fsevent"
  spec.add_development_dependency "terminal-notifier"
  spec.add_development_dependency "terminal-notifier-guard"
end
