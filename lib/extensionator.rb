require_relative "extensionator/error"
require_relative "extensionator/manifest"
require_relative "extensionator/crx"
require_relative "extensionator/creator"

module Extensionator

  def self.validate(dir, opts={})
    Creator.new(dir, opts).validate
  end

  def self.crx(dir, identity_file, dest_filename, opts = {})
    Creator.new(dir, opts.merge(identity: identity_file)).crx(dest_filename)
  end

  def self.zip(dir, dest_filename, opts= {})
    Creator.new(dir, opts).zip(dest_filename)
  end

  def self.copy(dir, dest_directory, opts= {})
    Creator.new(dir, opts).copy(dest_directory)
  end

  ##deprecated, reverse compat
  def self.create(dir, identity_file, dest_filename, opts = {})
    crx(dir, identity_file, dest_filename, opts)
  end
end
