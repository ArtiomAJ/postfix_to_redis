yum_package 'epel-release' do
  action :install
end

execute 'install-ruby-version-manager' do
 command "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB"
 ignore_failure true
 action :run
end

execute 'install-ruby' do
 command "\\curl -sSL https://get.rvm.io | bash -s stable --ruby=2.4.1"
 action :run
end

execute 'set-rvm-ruby' do
 command "rvm use 2.4.1"
 action :run
end

gem_package 'redis' do
 action :install
end

gem_package 'mail' do
 action :install
end

