#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path '../config/environments/config_variables', __FILE__
require File.expand_path('../config/application', __FILE__)

EfarDispatch::Application.load_tasks

desc "core deployment build"
task :before_deploy do
  system("RAILS_ENV=production bundle exec rake assets:precompile")
  system("git add . ")
  system("git commit -a -m 'auto-build #{Time.now.strftime("%a, %b %d @ %I:%M%p")}'")
end

task :deploy => :before_deploy do
  exec("git push heroku master")
end