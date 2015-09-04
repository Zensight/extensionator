require "fileutils"
require "minitest/autorun"
require "open-uri"
require "zip"
require "json"
require "set"
require_relative "../lib/extensionator"

Dir.chdir File.dirname(__FILE__)

class TestExtensionator < Minitest::Test

  def teardown
    Dir.glob("*.{zip,json,crx}").each do |file|
      FileUtils.rm_rf(file)
    end
  end

  def test_create_alias
    Extensionator.create("basic", "dummy.pem", "output.crx")
    assert File.exists?("output.crx")
  end

  def test_crx
    Extensionator.crx("basic", "dummy.pem", "output.crx")
    assert File.exists?("output.crx")
  end

  def test_no_pem
  end

  def test_zip
    Extensionator.zip("basic", "simple.zip")
    assert_files("simple.zip", basic_files)
  end

  def test_exclusions
    Extensionator.zip("basic", "exclude_icon.zip", exclude: /icon\.png/, skip_validation: true)
    assert_files("exclude_icon.zip", basic_files("icon.png"))

    Extensionator.zip("basic", "exclude_popup.zip", exclude: /popup\..*/, skip_validation: true)
    assert_files("exclude_popup.zip", basic_files("popup.html", "popup.js"))
  end

  def test_injected_version
    Extensionator.zip("basic", "injected_version.zip", inject_version: "2.3")
    m = parsed_manifest("injected_version.zip")
    assert_equal m["version"], "2.3"
  end

  def test_injected_key
    Extensionator.zip("basic", "injected_version.zip", identity: "dummy.pem", inject_key: true)
    m = parsed_manifest("injected_version.zip")
    assert_equal(m["key"], "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsxID85exu98/XYJbZFQkBgokQmg93rbbtyFtZOmAHewwvYwvZBh7Ig9g9sUP1Z+nGUVNUefVlYUscAEbYwdKTC20fDl+4mgk4GidfqSMtTrX6ZodaeBLtIBiLdaBlfdriXmnCNLnryWHmIT5WW89jjo+jMq1Xgd2HIlPNKbJDQ0AF6xLLAkrsUPCXBq7+CiBIJAUod0YD2gW+TKDqJo1qKfYIa9w7TQNRK7wyETbzQtqe5b2OPrDDGRqCCXyLxZvCLUn/vkI3oNjrWHtfm7KrdPKxtm3l1CEiHQP5ghD5OzVm7us4ibUcYkK+XAob4p9ItzX+D/OE8vLtb09Q0SykQIDAQAB")
  end

  def basic_files(*except)
    files = Set.new(["icon.png", "manifest.json", "popup.html", "popup.js"])
    except ? files - except : files
  end

  def except_file(file)
    @@basic_files - [file]
  end

  def assert_files(zip_file, file_set)
    assert(File.exists?(zip_file), "Zip file #{zip_file} exists")
    zip_files = Set.new
    Zip::File.open(zip_file) do |zip|
      zip.each do |entry|
        zip_files << entry.name
      end
    end
    assert_equal(file_set, zip_files, "File sets are equal")
  end

  def parsed_manifest(zip_file)
    @i ||= 0
    @i += 1
    Zip::File.open(zip_file) do |zip|
      manifest_entry = zip.select{|entry| entry.name == "manifest.json"}.first
      manifest_entry.extract("manifest_#{@i}.json")
      JSON.parse(File.read("manifest_#{@i}.json"))
    end
  end

end
