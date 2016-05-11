require 'puppet-lint/tasks/puppet-lint'

ignore_paths =
  [
    "scripts/*.pp",
    "vendor/**/*.pp",
    "puppet/modules/**/**/*.pp",
  ]


Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = ignore_paths
  config.fail_on_warnings = true
end

task :default => [:lint]
