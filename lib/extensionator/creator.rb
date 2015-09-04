require "find"
require "fileutils"
require "openssl"
require "pathname"
require "zip"

module Extensionator
  class Creator

    def initialize(dir, options)
      @dir = dir
      @opts = options
      @opts[:exclude] ||= /\.crx$/
    end

    def zip(destination)
      with_zip do |zip_str|
        File.open(destination, "wb"){|f| f.write zip_str}
      end
    end

    def crx(destination)
      with_zip do |zip_str|
        CRX.create(destination, zip_str, private_key)
      end
    end

    def copy(destination)
      FileUtils.mkdir_p(destination)

      process_directory.each do |p|
        path_in_dir, file = p

        write_path = File.join(destination, path_in_dir)

        if File.directory?(file)
          FileUtils.mkdir_p(write_path)
        else
          FileUtils.cp(file, write_path)
        end
      end
    end

    def validate
      manifest.validate(dir_files)
    end

    private

    def with_zip
      files = process_directory
      yield zip_up(files)
    end

    def process_directory
      new_paths = dir_files

      manifest.validate(new_paths) unless @opts[:skip_validation]
      manifest.inject_key(private_key) if @opts[:inject_key]
      manifest.strip_key if @opts[:strip_key]
      manifest.inject_version(@opts[:inject_version]) if @opts[:inject_version]

      new_paths << manifest.write if manifest_updated?

      new_paths
    end

    def zip_up(paths)
      Zip.continue_on_exists_proc = true
      Zip::File.add_buffer do |zip|
        paths.each do |path_combo|
          path_in_zip, file = path_combo
          if File.directory?(file)
            zip.mkdir(path_in_zip)
          else
            zip.add(path_in_zip, file)
          end
        end
      end.string
    end

    def dir_files
      unless @dir_files
        @dir_files = []
        Find.find(@dir) do |path|
          case
            when path == @dir
              next
            when (@opts[:exclude] && path =~ @opts[:exclude])
              Find.prune
            else
              @dir_files << [relative_path(@dir, path), path]
          end
        end
      end
      @dir_files
    end

    def manifest
      @manifest ||= Manifest.new(@dir)
    end

    def manifest_updated?
      @manifest && @manifest.updated?
    end

    def private_key
      @private_key ||=
        if @opts[:identity]
          begin
            OpenSSL::PKey::RSA.new(File.read(@opts[:identity]))
          rescue Error => e
            raise KeyError.new("Couldn't read key file #{@opts[:identity]}: #{e.message}")
          end
        else
          raise ArgumentError.new("You need to specify an identity file for this operation.")
        end
    end

    def relative_path(base, target)
      from, to = [base, target].map(&Pathname.method(:new))
      to.relative_path_from(from).to_s
    end
  end
end
