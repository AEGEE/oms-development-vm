require 'puppet-lint/tasks/puppet-lint'

ignore_paths =
  [
    "vendor/**/*.pp",
    "puppet/modules/apt/**/*.pp",
    "puppet/modules/augeasprovider_core/**/*.pp",
    "puppet/modules/augeasprovider_shellvar/**/*.pp",
    "puppet/modules/composer/**/*.pp",
    "puppet/modules/git/**/*.pp",
    "puppet/modules/ldapdn/**/*.pp",
    "puppet/modules/nodejs/**/*.pp",
    "puppet/modules/openldap/**/*.pp",
    "puppet/modules/php/**/*.pp",
    "puppet/modules/phpldapadmin/**/*.pp",
    "puppet/modules/puppi/**/*.pp",
    "puppet/modules/stdlib/**/*.pp",
    "puppet/modules/vcsrepo/**/*.pp",
  ]


Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = ignore_paths
end

task :default => [:lint]
