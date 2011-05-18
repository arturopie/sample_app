# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

# require the hydra codebase
require 'hydra'
# require the hydra rake task helpers
require 'hydra/tasks'


# set up a new hydra testing task named 'hydra:spec' run with "rake hydra:spec"
Hydra::TestTask.new('hydra:spec') do |t|
  # you may or may not need this, depending on how you require
  # spec_helper in your test files:
  require 'spec/spec_helper'
  # add all files in the spec directory that end with "_spec.rb"
  t.add_files 'spec/**/*_spec.rb'
  # t.verbose = true
  # t.show_time = false
end

SampleApp::Application.load_tasks
