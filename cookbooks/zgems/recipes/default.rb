bash 'install bundler' do 
  code 'gem install bundler'
  not_if "gem list | grep bundler"
end