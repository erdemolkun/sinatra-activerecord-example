require "bundler/setup"
require "sinatra/activerecord/rake"
require "./application"

task :default => ["run:development"]

namespace :run do
  desc "Start Development Server (local)"
  task :development do
    system "shotgun"
  end
end

desc "Start interactive console (tux)"
task :tux do
  system "tux"
end