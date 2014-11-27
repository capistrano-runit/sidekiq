include ::Capistrano::Runit

namespace :load do
  task :defaults do
    set :runit_sidekiq_concurrency, nil
    set :runit_sidekiq_pid, -> { File.join(shared_path, 'tmp', 'pids', 'sidekiq.pid') }
    set :runit_sidekiq_queues, nil
    set :runit_sidekiq_require, nil
    set :runiq_sidekiq_config_path, nil
    set :runit_sidekiq_default_hooks, -> { true }
    set :runit_sidekiq_role, -> { :app }
    # Rbenv and RVM integration
    set :rbenv_map_bins, fetch(:rbenv_map_bins).to_a.concat(%w(sidekiq))
    set :rvm_map_bins, fetch(:rvm_map_bins).to_a.concat(%w(sidekiq))
  end
end

namespace :deploy do
  before :starting, :runit_check_sidekiq_hooks do
    invoke 'runit:sidekiq:add_default_hooks' if fetch(:runit_sidekiq_default_hooks)
  end
end

namespace :runit do
  namespace :sidekiq do
    # Helpers

    def sidekiq_enabled_service_dir
      enabled_service_dir_for('sidekid')
    end

    def sidekiq_service_dir
      service_dir_for('sidekiq')
    end

    def collect_sidekiq_run_command
      array = []
      collect_default_sidekiq_params(array)
      collect_concurrency_sidekiq_params(array)
      collect_queues_sidekiq_params(array)
      collect_log_sidekiq_param(array)
      collect_pid_sidekiq_param(array)
      collect_config_sidekiq_param(array)
      collect_require_sidekiq_params(array)
      array.compact.join(' ')
    end

    def sidekiq_environment
      @sidekiq_environment ||= fetch(:rack_env, fetch(:rails_env, 'production'))
    end

    def collect_default_sidekiq_params(array)
      array << env_variables
      array << "exec #{SSHKit.config.command_map[:bundle]} exec sidekiq"
      array << "-e #{sidekiq_environment}"
      array << "-g #{fetch(:application)}"
    end

    def collect_concurrency_sidekiq_params(array)
      concurrency = fetch(:runit_sidekiq_concurrency)
      return unless concurrency
      array << "-c #{concurrency}"
    end

    def collect_require_sidekiq_params(array)
      require_file_or_folder = fetch(:runit_sidekiq_require)
      return unless require_file_or_folder
      array << "-r #{require_file_or_folder}"
    end

    def collect_queues_sidekiq_params(array)
      queues = fetch(:runit_sidekiq_queues)
      if queues && queues.is_a?(::Array)
        queues.map do |q|
          array << "-q #{q}" if q.is_a?(::String)
        end
      end
    end

    def collect_config_sidekiq_param(array)
      if (config_path = fetch(:runiq_sidekiq_config_path))
        array << "-C #{config_path}"
      end
    end

    def collect_log_sidekiq_param(array)
      array << "-L #{File.join(shared_path, 'log', "sidekiq.#{sidekiq_environment}.log")}"
    end

    def collect_pid_sidekiq_param(array)
      array << "-P #{pid_full_path(fetch(:runit_sidekiq_pid))}"
    end

    task :add_default_hooks do
      after 'deploy:check', 'runit:sidekiq:check'
      after 'deploy:starting', 'runit:sidekiq:quiet'
      after 'deploy:updated', 'runit:sidekiq:stop'
      after 'deploy:reverted', 'runit:sidekiq:stop'
      after 'deploy:published', 'runit:sidekiq:start'
    end

    task :check do
      check_service('sidekiq')
    end

    desc 'Setup sidekiq runit service'
    task :setup do
      setup_service('sidekiq', collect_sidekiq_run_command)
    end

    desc 'Enable sidekiq runit service'
    task :enable do
      enable_service('sidekiq')
    end

    desc 'Disable sidekiq runit service'
    task :disable do
      disable_service('sidekiq')
    end

    desc 'Start sidekiq runit service'
    task :start do
      start_service('sidekiq')
    end

    desc 'Stop sidekiq runit service'
    task :stop do
      stop_service('sidekiq')
    end

    desc 'Restart sidekiq runit service'
    task :restart do
      restart_service('sidekiq')
    end

    desc 'Quiet sidekiq (stop accepting new work)'
    task :quiet do
      pid_file = pid_full_path(fetch(:runit_sidekiq_pid))
      on roles fetch(:runit_sidekiq_role) do
        if test "[ -f #{pid_file} ]" && test("kill -0 $( cat #{pid_file})")
          runit_execute_command('sidekiq', '1')
        else
          info 'Sidekiq is not running'
          if test("[ -f #{pid_file} ]")
            info 'Removing broken pid file'
            execute :rm, '-f', pid_file
          end
        end
      end
    end
  end
end
