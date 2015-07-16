# bash 'install_pg' do
#   cwd "/"
#   user "vagrant"
# code <<-EOH
#   sudo apt-get --yes --force-yes install postgresql postgresql-contrib libpq-dev
# EOH
# not_if { ::File.exists?("/usr/lib/postgresql/9.3/bin/postgres") }
# end

package "postgresql"
package "postgresql-contrib"
package "libpq-dev"

bash 'create_pg_user' do
   cwd "/"
   user "vagrant"
   code <<-EOH 
     sudo -u postgres psql -c "create user dbuser with password 'db123456' superuser"
   EOH
   not_if 'psql -c "\du" | grep dbuser', :user => "postgres"
end

# bash 'install_pg' do
#   cwd "/"
#   user "vagrant"
# code <<-EOH
#   sudo /usr/local/rvm/bin/rvm default do gem install pg --no-ri --no-rdoc
#   sudo /usr/local/rvm/bin/rvm default do gem install json -v '1.8.3'
# EOH
# end

gem_package "pg"

gem_package "json" do
  version "1.8.2"
end


