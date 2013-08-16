set :application,   'breakpoint-app'
set :repo_url,      'git@github.com:davekaro/breakpoint-app.git'
set :deploy_to,     '/home/breakpointapp/app'

set :linked_files, %w{.env config/unicorn.rb}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets}

