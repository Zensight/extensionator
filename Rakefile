require "bundler"
Bundler::GemHelper.install_tasks

task :test do
  Dir.glob("./test/*_test.rb").each { |file| require file}
end
