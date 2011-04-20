require 'bundler'
Bundler::GemHelper.install_tasks

require 'bueller'
Bueller::Tasks.new

require 'cucumber/rake/task'

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--format pretty}
end