set :application, "mxor"
set :deploy_to, "/path/to/your/app"
server "mexicoonrails.com.mx", :app, :web, :db, :primary => true
default_run_options[:pty] = true

set :scm, :git
set :repository,  "git@github.com:edgarjs/mexico_on_rails.git"
set :deploy_via, :remote_cache
