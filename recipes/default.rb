#
# Cookbook:: postfix_to_redis
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#


file "/tmp/local_mode.txt" do
    content "created by chef client local mode"
end

include_recipe 'postfix_to_redis::ruby'
include_recipe 'postfix_to_redis::redis'
include_recipe 'postfix_to_redis::postfix'
include_recipe 'postfix_to_redis::datafiles'
