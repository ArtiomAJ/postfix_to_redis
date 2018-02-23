#!/usr/local/rvm/rubies/ruby-2.4.1/bin/ruby

require 'redis'

def read_from_redis(toadr)

redis = Redis.new(:host => '127.0.0.1', :port => 6379)
array = redis.keys()
array.each { |key|
  if key != 'mail:id'
    if redis.hget(key, 'To:') == toadr
      mail = redis.hgetall(key)
        puts mail
    end
  end }
end

require 'optparse'

OptionParser.new do |parser|
  parser.on("-e", "--email ADRESS",  "Require Email adress") do |toadr|
    read_from_redis(toadr)  
  end
end.parse!
