require_relative "extensionator/error"
require_relative "extensionator/manifest"
require_relative "extensionator/crx"
require_relative "extensionator/creator"

module Extensionator

  def self.create(kind, dir, dest, opts={})
    Creator.new(dir, opts).send(kind, dest)
  end

  def self.validate(dir, opts={})
    Creator.new(dir, opts).validate
  end

  def self.crx(dir, dest_filename, opts)
    Creator.new(dir, opts).crx(dest_filename)
  end

  def self.zip(dir, dest_filename, opts= {})
    Creator.new(dir, opts).zip(dest_filename)
  end

  def self.copy(dir, dest_directory, opts= {})
    Creator.new(dir, opts).copy(dest_directory)
  end
end
