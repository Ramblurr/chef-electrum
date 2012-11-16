#
# Cookbook Name:: electrum-server
# Recipe:: basic server
#
# Copyright (C) 2012 Casey Link <unnamedrambler@gmail.com>
#

include_recipe "python::pip"
include_recipe "python::virtualenv"

# install dependencies

if platform?("debian")
  package "libdb4.8-dev"
  package "libboost-all-dev"
  package "libssl-dev"
end

if platform?("ubuntu")
  apt_repository "bitcoin" do
      uri "http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu"
      distribution node['lsb']['codename']
      components ["main"]
      keyserver "keyserver.ubuntu.com"
      key "C70EF1F0305A1ADB9986DBD8D46F45428842CE5E"
  end
  package "libdb4.8-dev"
  package "libdb4.8++-dev"
  package "libboost-all-dev"
  package "libssl-dev"
end

python_pip "jsonrpclib" do
  virtualenv "#{node['electrum']['prefix']}"
  action :install
end

# fetch electrum sources

git "#{node['electrum']['prefix']}/src/electrum" do
  repository "https://github.com/spesmilo/electrum-server.git"
  reference "master"
  action :sync
end

# build patched bitcoind

git "#{node['electrum']['prefix']}/src/bitcoin" do
  repository "git://github.com/bitcoin/bitcoin.git"
  reference "v0.7.1"
  action :sync
end

bash "build_bitcoind" do
  not_if "stat #{node['electrum']['prefix']}/bin/bitcoind"
  user "root"
  cwd "#{node['electrum']['prefix']}/src/bitcoin"
  code <<-EOF
    patch -N -p1 < #{node['electrum']['prefix']}/src/electrum/patch/patch
    cd src && make -f makefile.unix USE_UPNP= USE_IPV6=1 -j2 && cp ./bitcoind #{node['electrum']['prefix']}/bin/bitcoind
  EOF
end

# setup system user

user_account node['electrum']['user'] do
  comment   'Bitcoin user'
  home      "/home/#{node['electrum']['user']}"
  system_user false
  shell '/bin/false'
end

# configure bitcoind

directory "/home/#{node['electrum']['user']}/.bitcoin/" do
  owner node['electrum']['user']
  group node['electrum']['user']
  mode "600"
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

# configure electrum

template "/etc/electrum.conf" do
  source "electrum.conf.erb"
  owner node['electrum']['user']
  group node['electrum']['user']
  mode "600"
  variables :conf=> node["electrum"]["conf"].to_hash
end

# bootstrap

remote_file "/home/#{node['electrum']['user']}/.bitcoin/bootstrap.dat" do
  only_if { node['electrum']['bootstrap'] }
  source node['electrum']['bootstrap_url']
  checksum node['electrum']['bootstrap_sha256']
end
