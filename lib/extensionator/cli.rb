require "slop"
require_relative "../extensionator"

module Extensionator
  module CLI
    def self.start
      opts = Slop.parse do |o|
        o.string "-d", "--directory", "Directory containing the extension. (Default: .)"
        o.string "-i", "--identity", "Location of the pem file to sign with."
        o.string "-o", "--output", "Location of the output file. (Default: 'extension.[zip|crx]')"
        o.string "-e", "--exclude", "Regular expression for filenames to exclude. (Default: \.crx$)"
        o.string "-f", "--format", "Type of file to produce, either zip or crx. (Default: crx)"
        o.string "--inject-version", "Inject a version number into the manifest file. (Default: none)"
        o.bool "--inject-key", "Inject a key parameter into the manifest file. (Default: no)"
        #o.string "--skip-validation", "Don't try to validate this extension."
        o.on "-v", "--version", "Extensionator version info." do
          puts Extensionator::VERSION
          exit
        end
        o.on "-h", "--help", "Print this message." do
          puts o
          exit
        end
      end

      creator = Creator.new(opts[:directory], opts)
      if opts[:format] == "zip"
        creator.zip(opts[:output] || "output.zip")
      else
        creator.crx(opts[:output] || "output.crx")
      end

    end

    def self.fixup_options(in_opts)
      opts = in_opts.clone
      opts[:output] = output.to_sym if opts[:output]
      opts[:exclude] = Regexp.new(opts[:exclude]) if opts[:exclude]
    end
  end
end
