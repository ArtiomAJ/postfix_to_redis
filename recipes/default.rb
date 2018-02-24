#
# Cookbook:: postfix_to_redis
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#



include_recipe 'postfix_to_redis::ruby'
include_recipe 'postfix_to_redis::redis'
include_recipe 'postfix_to_redis::postfix'
include_recipe 'postfix_to_redis::datafiles'
