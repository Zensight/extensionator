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
    Dir.glob("*.{zip,json,crx,dir}").each do |file|
      FileUtils.rm_rf(file)
    end
  end

  def test_create
    Extensionator.create(:crx, "basic", "output.crx", identity: "dummy.pem")
    assert File.exists?("output.crx")
  end

  def test_crx
    Extensionator.crx("basic", "output.crx", identity: "dummy.pem")
    assert File.exists?("output.crx")
  end

  def test_zip
    Extensionator.zip("basic", "simple.zip")
    assert_files_zip(basic_files, "simple.zip")
  end

  def test_exclusions
    Extensionator.zip("basic", "exclude_icon.zip", exclude: /icon\.png/, skip_validation: true)
    assert_files_zip(basic_files("icon.png"), "exclude_icon.zip")

    Extensionator.zip("basic", "exclude_popup.zip", exclude: /popup\..*/, skip_validation: true)
    assert_files_zip(basic_files("popup.html", "popup.js"), "exclude_popup.zip")
  end

  def test_injected_version
    Extensionator.zip("basic", "injected_version.zip", inject_version: "2.3")
    m = parse_manifest_zip("injected_version.zip")
    assert_equal "2.3", m["version"]
  end

  def test_stripped_key
    Extensionator.zip("with_key", "stripped_key.zip", strip_key: true)
    m = parse_manifest_zip("stripped_key.zip")
    assert_equal(nil, m["key"])
  end

  def test_copy
    Extensionator.copy("basic", "copy.dir")
    assert_files_dir(basic_files, "copy.dir")
  end

  def test_injected_key
    Extensionator.copy("basic", "injected_key.dir", identity: "dummy.pem", inject_key: true)
    m = parse_manifest("injected_key.dir/manifest.json")
    assert_equal("MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsxID85exu98/XYJbZFQkBgokQmg93rbbtyFtZOmAHewwvYwvZBh7Ig9g9sUP1Z+nGUVNUefVlYUscAEbYwdKTC20fDl+4mgk4GidfqSMtTrX6ZodaeBLtIBiLdaBlfdriXmnCNLnryWHmIT5WW89jjo+jMq1Xgd2HIlPNKbJDQ0AF6xLLAkrsUPCXBq7+CiBIJAUod0YD2gW+TKDqJo1qKfYIa9w7TQNRK7wyETbzQtqe5b2OPrDDGRqCCXyLxZvCLUn/vkI3oNjrWHtfm7KrdPKxtm3l1CEiHQP5ghD5OzVm7us4ibUcYkK+XAob4p9ItzX+D/OE8vLtb09Q0SykQIDAQAB",
                 m["key"] )
  end

  def basic_files(*except)
    files = ["icon.png", "manifest.json", "popup.html", "popup.js", "nested/file.txt"].to_set
    except ? files - except : files
  end

  def except_file(file)
    @@basic_files - [file]
  end

  def assert_files_zip(file_set, zip_file)
    assert(File.exists?(zip_file), "Zip file #{zip_file} exists")
    zip_files = Set.new
    Zip::File.open(zip_file) do |zip|
      zip.each do |entry|
        if entry.ftype != :directory
          zip_files << entry.name
        end
      end
    end
    assert_equal(file_set, zip_files, "File sets are equal")
  end

  def assert_files_dir(file_set, dir)
    assert_equal(file_set.map{|i| "#{dir}/#{i}"}.to_set,
                 Dir.glob("#{dir}/**/*").select{|p| !File.directory?(p)}.to_set,)
  end

  def parse_manifest_zip(zip_file)
    @i ||= 0
    @i += 1
    Zip::File.open(zip_file) do |zip|
      manifest_entry = zip.select{|entry| entry.name == "manifest.json"}.first
      manifest_entry.extract("manifest_#{@i}.json")
      parse_manifest("manifest_#{@i}.json")
    end
  end

  def parse_manifest(file_path)
    JSON.parse(File.read(file_path))
  end

end
