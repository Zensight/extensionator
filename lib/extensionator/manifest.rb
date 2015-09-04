require "json"
require "base64"

module Extensionator
  class Manifest

    def initialize(dir)
      manifest_file = "#{dir}/manifest.json"

      raise "Can't find manifest file" unless File.exists? manifest_file

      begin
        @manifest = JSON.parse(File.read(manifest_file))
      rescue Errno::ENOTENT => e
        raise ValidationError.new("Can't read manifest file: #{e.message}")
      rescue JSON::ParserError => e
        raise ValidationError.new("Can't parse manifest file: #{e.message}")
      end
    end

    def validate(paths)
      #todo: actual validations!
      true
    end

    def inject_key(priv_key)
      #Chrome appears to support some shorter encoding of the pub key, but I'm not sure what it is
      @manifest["key"] = Base64.encode64(priv_key.public_key.to_der).gsub("\n", "")
      @updated = true
    end

    def inject_version(version)
      @manifest["version"] = version
      @updated = true
    end

    def updated?
      @updated || false
    end

    def write
      file = Tempfile.new("crx-manifest.json")
      File.open(file, "w"){|f| f.write(JSON.dump(@manifest))}
      ["manifest.json", file.path]
    end
  end
end
