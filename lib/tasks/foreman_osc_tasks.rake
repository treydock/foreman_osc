require 'rake/testtask'

# Tests
namespace :test do
  desc 'Test ForemanOsc'
  Rake::TestTask.new(:foreman_osc) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
    t.warning = false
  end
end

namespace :foreman_osc do
  desc 'Run rubocop for ForemanOsc'
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_osc) do |task|
        task.patterns = ["#{ForemanOsc::Engine.root}/app/**/*.rb",
                         "#{ForemanOsc::Engine.root}/lib/**/*.rb",
                         "#{ForemanOsc::Engine.root}/test/**/*.rb"]
      end
    rescue
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_foreman_osc'].invoke
  end
end

Rake::Task[:test].enhance ['test:foreman_osc']

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance ['test:foreman_osc', 'foreman_osc:rubocop']
end
