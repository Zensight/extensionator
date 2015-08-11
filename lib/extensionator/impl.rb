require "digest/sha1"
require "find"
require "openssl"
require "pathname"
require "zip"

module Extensionator
  module Impl
    def self.create(dir, key_file, dest_filename, opts)
      priv_key = read_key(key_file)
      zip_str = zip(dir, opts)
      sig_bytes = sign(zip_str, priv_key)
      write(zip_str, sig_bytes, priv_key, dest_filename)
    end

    def self.read_key(key_file)
      OpenSSL::PKey::RSA.new(File.read(key_file))
    end

    def self.zip(dir, opts = {})
      Zip::File.add_buffer do |zip|
        Find.find(dir) do |path|
          case
            when path == dir
              next
            when  (opts[:exclude] && path =~ opts[:exclude])
              Find.prune
            when File.directory?(path)
              zip.mkdir(relative_path(dir, path))
            else
              zip.add(relative_path(dir, path), path)
          end
        end
      end.string
    end

    def self.sign(zip_str, priv_key)
      priv_key.sign(OpenSSL::Digest::SHA1.new, zip_str)
    end

    def self.write(zip_str, sig_bytes, priv_key, dest_filename)
      pub_key_bytes = priv_key.public_key.to_der

      #See https://developer.chrome.com/extensions/crx for the format description
      File.open(dest_filename, "wb") do |file|
        file << "Cr24"
        file << format_size(2)
        file << format_size(pub_key_bytes.size)
        file << format_size(sig_bytes.size)
        file << pub_key_bytes
        file << sig_bytes
        file << zip_str
      end
    end

    def self.relative_path(base, target)
      from, to = [base, target].map(&Pathname.method(:new))
      to.relative_path_from(from).to_s
    end

    def self.format_size(num)
      [num].pack("V")
    end
  end

end
