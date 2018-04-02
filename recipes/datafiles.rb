#user = node['current_user']

#unless Dir.exist? "/home/#{user}"
#directory "/home/#{user}" do
#  user node[:current_user]
#  group node[:root_group]
#  mode '0755'
#  action :create
#end
#end




template "/usr/sbin/put_data_to_redis.rb" do
  source 'put_data_to_redis.rb'
 #user node[:current_user]
 # user node[user] 
 # group node[:root_group]
  user root
  group root
  mode 0770
  end

template "/usr/sbin/read_from_redis.rb" do
  source 'read_from_redis.rb'
  #user node[:current_user]
  #group node[:root_group]
  user root
  group root
  mode 0770
  end

execute 'chcon-postfix' do
command "chcon -t postfix_local_exec_t /usr/sbin/put_data_to_redis.rb"
end

#update aliases. chef template is not used to keep existing aliases 
ruby_block "add_forward_aliases" do
  block do
    file = Chef::Util::FileEdit.new("/etc/aliases")
    file.insert_line_if_no_match("root: \"|/usr/sbin/put_data_to_redis.rb\"/", "root: \"|/usr/sbin/put_data_to_redis.rb\"")    
    file.write_file
    file.file_edited?
    end
  notifies :run, 'execute [update-alieases]', :immediately 
end

execute 'update-alieases' do
command "newaliases"
action :nothing
end


execute 'back-up-main-cf' do
command "mv /etc/postfix/main.cf /etc/postfix/main.cf.original"
not_if do
  File.exist?('/etc/postfix/main.cf.original')
end

template "/etc/postfix/main.cf" do
  source 'main.cf'
 notifies :restart, 'service[postfix]'
end
