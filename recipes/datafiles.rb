user = node['current_user']

unless Dir.exist? "/home/#{user}"
directory "/home/#{user}" do
  user node[:current_user]
  group node[:root_group]
  mode '0755'
  action :create
end
end




template "/home/#{user}/put_data_to_redis.rb" do
  source 'put_data_to_redis.rb'
  user node[:current_user]
  group node[:root_group]
  mode 0755
  end

template "/home/#{user}/read_from_redis.rb" do
  source 'read_from_redis.rb'
  user node[:current_user]
  group node[:root_group]
  mode 0755
  end

execute 'chcon-postfix' do
command "chcon -t postfix_local_exec_t /home/#{user}/put_data_to_redis.rb"
end

ruby_block "add_forward_aliases" do
  block do
    file = Chef::Util::FileEdit.new("/etc/aliases")
    file.insert_line_if_no_match("/#{user}: \"|/home/#{user}/put_data_to_redis.rb\"/", "#{user}: \"|/home/#{user}/put_data_to_redis.rb\"")    
    file.write_file
  end
end

execute 'update-alieases' do
command "newaliases"
end


execute 'back-up-main-cf' do
command "mv /etc/postfix/main.cf /etc/postfix/main.cf.original"
end

template "/etc/postfix/main.cf" do
  source 'main.cf'
 notifies :restart, 'service[postfix]'
end
