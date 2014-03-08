set :application,   'breakpoint-app'
set :repo_url,      'git@github.com:davekaro/breakpoint-app.git'
set :deploy_to,     '/home/breakpointapp/app'

set :linked_files, %w{.env config/unicorn.rb}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute fetch(:chruby_exec), "#{fetch(:chruby_ruby)} -- service breakpointapp restart"
      execute :restart, "workers" # restart sidekiq
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within latest_release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end

set :chruby_ruby, `cat .ruby-version | tr -d "\n"`

