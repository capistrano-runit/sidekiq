# capistrano-runit-sidekiq

Capistrano3 tasks for manage sidekiq via runit supervisor.

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-runit-sidekiq'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-runit-sidekiq

## Usage

Add this line in `Capfile`:
```
require "capistrano/runit/sidekiq"
```

## Tasks

* `runit:sidekiq:setup` -- setup sidekiq runit service.
* `runit:sidekiq:enable` -- enable and autostart service.
* `runit:sidekiq:disable` -- stop and disable service.
* `runit:sidekiq:start` -- start service.
* `runit:sidekiq:stop` -- stop service.
* `runit:sidekiq:restart` -- restart service.

## Variables

* `runit_sidekiq_default_hooks` -- run default hooks for runit sidekiq or not. Default value: `true`.
* `runit_sidekiq_role` -- Role on where sidekiq will be running. Default value: `:app`
* `runit_sidekiq_pid` -- Pid file path. Default value: `tmp/sidekiq.pid`
* `runit_sidekiq_run_template` -- path to ERB template of `run` file. Default value: internal default template (`lib/capistrano/runit/templates/run-puma.erb`).
* `runit_sidekiq_concurrency` -- number of threads of sidekiq process. Default value: `nil`.
* `runit_sidekiq_queues` -- array of queue names. Default value: `nil`.
* `runit_sidekiq_config_path` -- relative path to config file. Default value: `nil`.

## Contributing

1. Fork it ( https://github.com/capistrano-runit/capistrano-runit-sidekiq/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
