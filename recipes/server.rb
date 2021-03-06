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
  package "libdb4.8++-dev"
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
      not_if "dpkg -l | grep libdb4.8++ &> /dev/null"
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
  reference node['electrum']['bitcoin_tag']
  action :sync
end

bash "build_bitcoind" do
  not_if { not node['electrum']['bitcoin_force'] and File.exists?("#{node['electrum']['prefix']}/bin/bitcoind") }
  user "root"
  cwd "#{node['electrum']['prefix']}/src/bitcoin"
  code <<-EOF
    patch -N -p1 < #{node['electrum']['prefix']}/src/electrum/patch/patch
    cd src && make -f makefile.unix USE_UPNP= USE_IPV6=1 && cp ./bitcoind #{node['electrum']['prefix']}/bin/bitcoind
  EOF
end

# setup system users

user_account node['electrum']['electrum_user'] do
  comment   'electrum user'
  manage_home false
  system_user false
  shell '/bin/false'
  ssh_keygen 'false'
end

user_account node['electrum']['bitcoin_user'] do
  comment   'Bitcoin user'
  home      "/home/#{node['electrum']['bitcoin_user']}"
  system_user false
  shell '/bin/false'
  ssh_keygen 'false'
end

# load bitcoin.conf configuration from databag and override

bitcoin_config = data_bag_item('electrum', 'bitcoin')['config']
node.override['electrum']['bitcoin'] = bitcoin_config

# configure bitcoind

directory "/home/#{node['electrum']['bitcoin_user']}/.bitcoin/" do
  owner node['electrum']['bitcoin_user']
  group node['electrum']['bitcoin_user']
  mode "700"
  action :create
end

template "/home/#{node['electrum']['bitcoin_user']}/.bitcoin/bitcoin.conf" do
  source "bitcoin.conf.erb"
  owner node['electrum']['bitcoin_user']
  group node['electrum']['bitcoin_user']
  variables :conf=> node['electrum']['bitcoin'].to_hash
  mode "700"
end

# load configuration from databag and override

config = data_bag_item('electrum', 'conf')['config']
node.override['electrum']['conf'] = config
node.override['electrum']['conf']['bitcoind']['user'] = node['electrum']['bitcoin']['rpcuser']
node.override['electrum']['conf']['bitcoind']['password'] = node['electrum']['bitcoin']['rpcpassword']

# install tls certs

certs = data_bag_item('electrum', 'certs')

if certs['ssl_cert']
    directory node['electrum']['certs_path'] do
      owner node['electrum']['electrum_user']
      group node['electrum']['electrum_user']
      mode "640"
      action :create
    end
end

if certs['ssl_cert']
    template "#{node['electrum']['certs_path']}/electrum.crt" do
        source 'cert.erb'
        owner node['electrum']['electrum_user']
        owner node['electrum']['electrum_user']
        mode '0640'
        variables :cert => certs['ssl_cert']
    end
    node.set['electrum']['conf']['server']['ssl_certfile'] = "#{node['electrum']['certs_path']}/electrum.crt"
end

if certs['ssl_key']
    template "#{node[:electrum][:certs_path]}/electrum.key" do
        source 'cert.erb'
        owner node[:electrum][:electrum_user]
        owner node[:electrum][:electrum_user]
        mode '0640'
        variables :cert => certs['ssl_key']
    end
    node.set['electrum']['conf']['server']['ssl_keyfile'] = "#{node['electrum']['certs_path']}/electrum.key"
end

# configure electrum

template "/etc/electrum.conf" do
  source "electrum.conf.erb"
  owner node['electrum']['electrum_user']
  group node['electrum']['electrum_user']
  mode "600"
  variables :conf=> node['electrum']['conf'].to_hash
end

# install init scripts and binary wrappers

template "#{node['electrum']['prefix']}/bin/electrum-start" do
  source "electrum-start.erb"
  owner "root"
  group "root"
  mode "755"
end

template "#{node['electrum']['prefix']}/bin/electrum-stop" do
  source "electrum-stop.erb"
  owner "root"
  group "root"
  mode "755"
end

template "/etc/init.d/bitcoind" do
  source "bitcoind.init.erb"
  owner "root"
  group "root"
  mode "755"
  notifies :enable, "service[bitcoind]"
end

template "/etc/init.d/electrum" do
  source "electrum.init.erb"
  owner "root"
  group "root"
  mode "755"
  notifies :enable, "service[electrum]"
end

directory "/var/log/electrum" do
  owner node['electrum']['electrum_user']
  group node['electrum']['electrum_user']
  mode "700"
  action :create
end

# go go services!

service "bitcoind" do
  supports :restart => true, :start => true, :stop => true, :reload => true
  action :nothing
end

service "electrum" do
  supports :restart => true, :start => true, :stop => true, :reload => true
  action :nothing
end
