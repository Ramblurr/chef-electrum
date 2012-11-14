#
# Cookbook Name:: electrum-server
# Recipe:: default
#
# Copyright (C) 2012 Casey Link <unnamedrambler@gmail.com>
# 
#
include_recipe "python::pip"
include_recipe "python::virtualenv"
include_recipe "bitcoin-abe"

package "bitcoind"

python_pip "jsonrpclib" do
  virtualenv "#{node['bitcoin-abe']['python_dir']}"
  action :install
end

git "#{node['bitcoin-abe']['dir']}/electrum" do
  repository "https://github.com/spesmilo/electrum-server.git"
  reference "master"
  action :sync
end

user_account node['electrum']['user'] do
  comment   'Bitcoin user'
  home      "/home/#{node['electrum']['user']}"
  system_user false
  shell '/bin/false'
end
directory "/home/#{node['electrum']['user']}/.bitcoin/" do
  owner node['electrum']['user']
  group node['electrum']['user']
  action :create
end

passwords = data_bag_item('electrum', 'passwords')

template "/home/#{node['electrum']['user']}/.bitcoin/bitcoin.conf" do
  source "bitcoin.conf.erb"
  owner node['electrum']['user']
  group node['electrum']['user']
  variables(:rpcuser => passwords['bitcoind']['rpcuser'],
            :rpcpass => passwords['bitcoind']['rpcpass'])
  mode "600"
end


