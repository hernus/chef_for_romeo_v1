bash "apt-key" do 
  code "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7"
end

file '/etc/apt/sources.list.d/passenger.list' do
  content 'deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main'
  mode '0600'
  owner 'root'
  group 'root'
end

bash "update_aptitude_cache" do
  code "sudo apt-get update"
end

# bash "install_nginx" do 
#   code "apt-get intall nginx-extras passenger"
# end

package 'nginx-extras' 

package 'passenger'

ruby_block "update_nginx_config" do 
  block do 
    line1 = "passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;"
    line2 = "passenger_ruby /usr/local/rvm/wrappers/default/ruby;"
    file = Chef::Util::FileEdit.new('/etc/nginx/nginx.conf')
    file.search_file_replace_line(/#\s*passenger_root/, line1)
    file.search_file_replace_line(/#\s*passenger_ruby/, line2)
    file.write_file
  end
end

file "/etc/nginx/sites-available/romeo" do
content <<-EOH 
server {
  listen 80 default_server;
  passenger_enabled on;
  passenger_app_env development;
  root /sites/#{node[:site_name]}/public;
}
EOH
   owner 'root'
   group 'root'
   mode  '0666'
end


