require "digest/sha1"

module Extensionator
  module CRX

    def self.create(destination, zip_str, priv_key)
      sig_bytes = sign(zip_str, priv_key)
      write_crx(destination, zip_str, sig_bytes, priv_key)
    end

    def self.sign(zip_str, priv_key)
      priv_key.sign(OpenSSL::Digest::SHA1.new, zip_str)
    end

    def self.write_crx(destination, zip_str, sig_bytes, priv_key)
      pub_key_bytes = priv_key.public_key.to_der

      #See https://developer.chrome.com/extensions/crx for the format description
      File.open(destination, "wb") do |file|
        file << "Cr24"
        file << format_size(2)
        file << format_size(pub_key_bytes.size)
        file << format_size(sig_bytes.size)
        file << pub_key_bytes
        file << sig_bytes
        file << zip_str
      end
    end

    def self.format_size(num)
      [num].pack("V")
    end
  end
end
