require_relative "extensionator/version"
require_relative "extensionator/cli"
require_relative "extensionator/impl"

module Extensionator
  def self.create(dir, key_file, dest_filename, opts = {exclude: /\.crx$/})
    Impl.create(dir, key_file, dest_filename, opts)
  end
end
