package "postgresql"
package "postgresql-contrib"
package "libpq-dev"

bash 'create_pg_user' do
   cwd "/"
   code <<-EOH 
     sudo -u postgres psql -c "create user deploy with password 'secret' superuser"
   EOH
   not_if 'psql -c "\du" | grep deploy', :user => "postgres"
end

# Also create user hernus, needed for restoring template database
bash 'create_pg_user' do
   cwd "/"
   code <<-EOH 
     sudo -u postgres psql -c "create user hernus with password 'secret' superuser"
   EOH
   not_if 'psql -c "\du" | grep hernus', :user => "postgres"
end

bash 'create_db' do
  cwd "/"
code <<-EOH
  sudo -u postgres createdb system_romeo_production -O deploy 
EOH
not_if "sudo -u postgres psql -l | grep system_romeo_production"
end


bash 'install_pg_gem' do
  cwd "/"
code <<-EOH
  gem install pg -- --no-ri --no-rdoc --with-pg-config=/usr/bin/pg_config   
EOH
not_if 'gem list | grep "^pg "'
end