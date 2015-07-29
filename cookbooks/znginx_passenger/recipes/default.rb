
unless File.exists? "/etc/apt/sources.list.d/passenger.list" 
  bash "apt-key" do 
    code "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7"
  end

  file '/etc/apt/sources.list.d/passenger.list' do
    content 'deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main'
    mode '0600'
    owner 'root'
    group 'root'
  end

  bash "apt-get update" do
    code "sudo apt-get update"
  end
end

package 'nginx-extras' 

package 'passenger'

# file "/etc/nginx/conf.d/passenger.conf" do 
#   content <<-EOF
#     passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;
#     passenger_ruby /usr/local/bin/ruby;
#   EOF
#   mode '0664'
#   owner 'root'
#   group 'root'
# end

template "/etc/nginx/nginx.conf" do 
  source "nginx.conf"
  mode "0664"
  owner "root"
  group "root"
end

file "/etc/nginx/sites-available/romeo" do
content <<-EOH 
server {
  listen 80 default_server;
  passenger_enabled on;
  passenger_app_env production;
  passenger_friendly_error_pages on;
  root /sites/system_romeo/current/public;
}
EOH
   owner 'root'
   group 'root'
   mode  '0666'
end


link "/etc/nginx/sites-enabled/default" do
  action :delete
end

link "/etc/nginx/sites-enabled/romeo" do
  to "/etc/nginx/sites-available/romeo"
  owner "root"
  mode "0666"
end

bash "reload nginx" do
  code "nginx -s reload"
end