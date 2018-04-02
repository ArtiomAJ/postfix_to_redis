package 'redis' do
end

service 'redis' do
  supports status: true, restart: true
action [ :enable, :start ]
end  
