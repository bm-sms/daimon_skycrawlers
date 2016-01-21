# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'daimon_skycrawlers/version'

Gem::Specification.new do |spec|
  spec.name          = "daimon_skycrawlers"
  spec.version       = DaimonSkycrawlers::VERSION
  spec.authors       = ["Ryunosuke SATO"]
  spec.email         = ["tricknotes.rs@gmail.com"]

  spec.summary       = %q{This is a crawler framework.}
  spec.description   = %q{This is a crawler framework.}
  spec.homepage      = "https://github.com/bm-sms/daimon-skycrawlers"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "perfectqueue"
  spec.add_dependency "mysql2"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "test-unit-rr"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "tapp"
end
