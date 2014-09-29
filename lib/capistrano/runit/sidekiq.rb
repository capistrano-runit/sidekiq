require 'capistrano/runit'
require 'erb'
load File.expand_path('../../tasks/sidekiq.rake', __FILE__)
