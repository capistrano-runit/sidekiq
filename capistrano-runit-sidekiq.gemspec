# coding: utf-8

Gem::Specification.new do |spec|
  spec.name        = "capistrano-runit-sidekiq"
  spec.version     = '0.2'
  spec.author      = ['Oleksandr Simonov', 'Anton Ageev']
  spec.email       = ['alex@simonov.me', 'antage@gmail.com']
  spec.summary     = %q{Capistrano3 tasks for manage sidekiq via runit supervisor.}
  spec.description = %q{Capistrano3 tasks for manage sidekiq via runit supervisor.}
  spec.homepage    = 'http://capistrano-runit.github.io'
  spec.license     = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'capistrano-runit-core', '~> 0.2.0'
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
