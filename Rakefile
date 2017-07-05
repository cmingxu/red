# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

task :deploy do
  system("git pull")
  system("docker build -t red .")
  system("docker rm -f rails-red")
  system("docker run --name rails-red -p 0.0.0.0:3001:3001 -v  /var/run/docker.sock:/var/run/docker.sock -d red")
end
