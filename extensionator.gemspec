lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.add_development_dependency "bundler", ">= 1.1", "< 3"
  spec.add_development_dependency "minitest", "~> 5.11"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_runtime_dependency "rubyzip", "~> 1.2"
  spec.add_runtime_dependency "slop", "~> 4.4"
  spec.authors = ["Isaac Cambron"]
  spec.description = "A tool for packaging Chrome extensions"
  spec.email = %w(isaac@isaaccambron.com)
  spec.executables = %w(extensionator)
  spec.files = %w(README.md extensionator.gemspec bin/extensionator) + Dir["lib/**/*.rb"]
  spec.homepage = "http://github.com/zensight/extensionator/"
  spec.licenses = %w(MIT)
  spec.name = "extensionator"
  spec.require_paths = %w(lib)
  spec.required_ruby_version = ">= 2.0.0"
  spec.required_rubygems_version = ">= 1.3.5"
  spec.summary = "Build and sign Chrome extensions (.crx files), either from the command line or using a Ruby API."

  require "extensionator/version"
  spec.version = Extensionator::VERSION
end
