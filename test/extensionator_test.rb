require "fileutils"
require "minitest/autorun"
require "open-uri"
require "zip"
require_relative "../lib/extensionator"
require_relative "helper"

Dir.chdir File.dirname(__FILE__)

class TestExtensionator < Minitest::Test

  def setup
    extract_zip("https://developer.chrome.com/extensions/examples/api/bookmarks/basic.zip")
  end

  def teardown
    begin
      FileUtils.rm_rf "basic"
      FileUtils.rm_rf "output.crx"
    rescue
    end
  end

  def test_basic_create
    Extensionator.create("basic", "dummy.pem", "output.crx")
    assert File.exists?("output.crx")
  end

  def extract_zip(url)
    Zip.on_exists_proc = true
    Zip::InputStream.open(open(url)) do |zip|
      while entry = zip.get_next_entry
        dir = File.dirname(entry.name)
        FileUtils.mkdir_p(dir) unless File.directory?(dir)
        entry.extract
      end
    end
  end
end
