require "slop"

module Extensionator
  module CLI
    def self.start
      opts = Slop.parse do |o|
        o.string "-d", "--directory", "Directory containing the extension. (Default: .)", default: "."
        o.string "-i", "--identity", "Location of the pem file to sign with. (Required)"
        o.string "-o", "--output", "Location of the output file. (Default: 'extension.crx')", default: "extension.crx"
        o.string "-e", "--exclude", "Regular expression for filenames to exclude. (Default: \.crx$)", default: nil
        o.on "-v", "--version", "Extensionator version info." do
          puts Extensionator::VERSION
          exit
        end
        o.on "-h", "--help", "Print this message." do
          puts o
          exit
        end
      end

      unless opts[:identity]
        abort("No identity file specified; use --identity or -i switch.")
      else
        Extensionator.create(opts[:directory],
                             opts[:identity],
                             opts[:output],
                             exclude: opts[:exclude] ? Regexp.new(opts[:exclude]) : nil)
      end
    end
  end
end
