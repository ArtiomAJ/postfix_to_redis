#!/usr/local/rvm/rubies/ruby-2.4.1/bin/ruby

require 'redis'
require 'mail'


def put_data_to_redis(data)

mail    = Mail.read_from_string(data)
from = mail.from  
to = mail.to              
subject = mail.subject   
date = mail.date.to_s   
message = mail.decoded       

redis = Redis.new(:host => '127.0.0.1', :port => 6379)
redis.incr('mail:id')
id = redis.get('mail:id')
puts id
redis.hmset(id, 'To:' ,to ,'From:', from, 'Date:', date, 'Subject:', subject, 'Message:', message)

end

put_data_to_redis($stdin.read)
