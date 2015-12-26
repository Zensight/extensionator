require "slop"
require_relative "../extensionator"

module Extensionator
  module CLI
    def self.start

      opts = parse_opts

      if opts.used_options.empty?
        puts opts
        exit
      end

       method, default = case opts[:format]
        when "zip" then [:zip, "output.zip"]
        when "dir" then [:copy, "output"]
        else [:crx, "output.crx"]
        end

       creator = Creator.new(opts[:directory] || ".", fixup_options(opts))
       creator.send(method, opts[:output] || default)
    end

    def self.parse_opts
      Slop.parse do |o|
        o.string "-d", "--directory", "Directory containing the extension. (Default: .)"
        o.string "-i", "--identity", "Location of the pem file to sign with."
        o.string "-o", "--output", "Location of the output file. (Default: 'output[.zip|.crx|]')"
        o.string "-e", "--exclude", "Regular expression for filenames to exclude. (Default: \.crx$)"
        o.string "-f", "--format", "Type of file to produce, either 'zip', 'dir' or 'crx'. (Default: crx)"
        o.string "--inject-version", "Inject a version number into the manifest file. (Default: none)"
        o.bool "--inject-key", "Inject a key parameter into the manifest file. (Default: no)"
        o.bool "--strip-key", "Remove the key parameter from the manifest file. (Default: no)"
        o.bool "--skip-validation", "Don't try to validate this extension. Currently just checks that the manifest is parsable."
        o.on "-v", "--version", "Extensionator version info." do
          puts Extensionator::VERSION
          exit
        end
        o.on "-h", "--help", "Print this message." do
          puts o
          exit
        end
      end
    end

    def self.fixup_options(in_opts)
      opts = in_opts.clone
      opts[:exclude] = Regexp.new(opts[:exclude]) if opts[:exclude]
      opts
    end
  end
end
