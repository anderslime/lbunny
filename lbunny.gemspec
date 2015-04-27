# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lbunny/version'

Gem::Specification.new do |spec|
  spec.name          = "lbunny"
  spec.version       = Lbunny::VERSION
  spec.authors       = ["Anders Emil Nielsen"]
  spec.email         = ["aemilnielsen@gmail.com"]

  spec.summary       = %q{A tiny Bunny wrapper for Lokalebasen's basic AMQP usage}
  spec.description   = %q{Wrapper around Bunny. For more see: http://rubybunny.info/}
  spec.homepage      = "http://github.com/lokalebasen/lbunny"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "bunny", "~> 1.7"
end
