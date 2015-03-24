lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "extensionator"

Gem::Specification.new do |spec|
  spec.add_dependency "rubyzip"
  spec.add_development_dependency "bundler", "~> 1.0"
  spec.authors = ["Isaac Cambron"]
  spec.description = 'A Ruby interface to the Twitter API.'
  spec.email = %w(icambron@gmail.com)
  spec.files = %w(README.md extensionator.gemspec) + Dir['lib/**/*.rb']
  spec.homepage = 'http://icambron.github.com/extensionator/'
  spec.licenses = %w(MIT)
  spec.name = 'extensionator'
  spec.require_paths = %w(lib)
  spec.required_ruby_version = '>= 1.9.3'
  spec.required_rubygems_version = '>= 1.3.5'
  spec.summary = spec.description
  spec.version = Extensionator::VERSION
end
