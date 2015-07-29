unless `whoami` =~ /root/
  puts "Please run as root, e.g. sudo chef-solo -c solo.rb"
  raise 
end

bash 'apt-get update' do
  cwd "/"
  user "root"
  code "apt-get update"
end

group "deploy"

user "deploy" do
  supports :manage_home => true
  gid 'deploy'
  home '/home/deploy'
  shell '/bin/bash'
  password 'deploy'
  not_if "ls /home/ | grep deploy"
end

directory '/sites' do
  owner node[:deploy_user]
  group node[:deploy_user]
  mode '0775'
  action :create
end