Dir["#{__dir__}/extensionator/*.rb"].each{|f| require f}

module Extensionator
  def self.create(dir, key_file, dest_filename, opts = {exclude: /\.crx$/})
    Impl.create(dir, key_file, dest_filename, opts)
  end
end
