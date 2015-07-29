ruby_folder  = "2.1"
ruby_v       = "2.1.6"
ruby_version = "ruby-#{ruby_v}"

package_list = %w{git openssl libssl-dev libcurl4-openssl-dev zlib1g zlib1g-dev libsasl2-dev libncurses5-dev libreadline-dev libxml2-dev python python-setuptools libxslt-dev build-essential nodejs}
package_list.each do |p|
   package p
end

package "ruby" do 
  action :purge
  only_if "ls /usr/bin/ | grep ruby"
end


# bash "remove old ruby" do 
#   code  <<-EOH
#     "apt-get purge ruby -y"  
#   EOH
#   only_if "dpkg --get-selections | grep ruby"
# end


bash 'install ruby' do
   code <<-EOH 
      cd /tmp  
      rm -Rf #{ruby_version}*        
      wget http://cache.ruby-lang.org/pub/ruby/#{ruby_folder}/#{ruby_version}.tar.gz          
      tar zxvf #{ruby_version}.tar.gz  
      cd #{ruby_version}  
      ./configure --disable-install-rdoc
      make -j4  
      make install  
      cd /tmp  
      rm -Rf #{ruby_version}*        
   EOH
   not_if "ls /usr/local/bin/ | grep ruby"
end

# link "/etc/bin/ruby" do
#   to "/etc/local/bin/ruby"
#   mode "0775"
#   owner "root"
# end

bash "upgrade gem" do
  code "gem update --system"
end

