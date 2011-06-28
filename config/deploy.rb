require 'bundler/capistrano'

set :application, "geoapi"
set :repository,  "git@github.com:benbruscella/GeoAPI.git"

task :production do
  
  
  puts "\n\n\n\n\n"
  puts "  * * * * * * * * * * * * * * * *\n"
  puts "  * * * * * * * * * * * * * * * *\n\n"

  puts "    OMG Deploying to PRODUCTION   \n"
  puts "    Shit just got real people...  \n\n"
  
  puts "  * * * * * * * * * * * * * * * *\n"
  puts "  * * * * * * * * * * * * * * * *\n"
  puts "\n\n\n\n\n"
  
  
  set :primary_server, "49.156.18.201"
  set :deploy_to, "/var/www/www.geoapi.com.au"
  
  set :user, "railsuser"
  ssh_options[:port] = 22
  
  set :scm, :git
  set :scm_verbose, true


  default_run_options[:pty] = true

  role :web, primary_server
  role :app, primary_server
  role :db,  primary_server, :primary => true
  
  ssh_options[:forward_agent] = true
  
end


# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do
    apache.start
  end

  task :stop do
    apache.stop
  end  
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end


namespace :apache do
  task :reload do
    sudo "apache2ctl graceful"
  end

  task :start do
    run "a2ensite #{application}"
    apache.reload
  end

  task :stop do
    run "a2dissite #{application}"
    apache.reload
  end

  task :restart do
    apache.start
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :configure do
    run "ln -sf #{current_path}/config/#{application}_vhost.conf /etc/apache2/sites-available/#{application}"
  end
end

desc "Symlink resources"
namespace :symlink do
  
  desc "uploads directory containing images and pdfs uploaded by users"
  task :uploads do
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end
  task :logs do
    run "ln -nfs #{shared_path}/log #{release_path}/log"
  end
  task :dbconfig do
    run "sudo ln -nfs #{shared_path}/config/mongoid.yml #{release_path}/config/mongoid.yml"
  end
  
end


# Symlink the upload directory to preserve 
# images and pdf's that have been uploaded
# by clients of scanoutlet
after :deploy, 'symlink:uploads'
after :deploy, 'symlink:logs'
after :deploy, 'symlink:dbconfig'
after :deploy, 'apache:configure'

