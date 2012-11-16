#
# Cookbook Name:: electrum-server
# Recipe:: leveldb storage
#
# Copyright (C) 2012 Casey Link <unnamedrambler@gmail.com>
#
include_recipe "python::pip"
include_recipe "python::virtualenv"

# install dependencies

if platform?("debian")
  if node[:platform_version].to_i < 7.0
    apt_repository "testing" do
      uri "http://ftp.us.debian.org/debian/"
      components ["wheezy","main", "contrib"]
    end
    apt_preference "libleveldb1" do
      pin "release a=testing"
      pin_priority "700"
    end
    apt_preference "python-leveldb" do
      pin "release a=testing"
      pin_priority "700"
    end
  end
  package "libleveldb1"
  package "python-leveldb"
end

if platform?("ubuntu")
  package "libleveldb-dev"
  package "python-leveldb"
end

node.default['electrum']['conf']['leveldb']['path'] = "/var/local/electrum"

directory node['electrum']['conf']['leveldb']['path'] do
  owner node['electrum']['electrum_user']
  group node['electrum']['electrum_user']
  mode "700"
  action :create
end

include_recipe "electrum::server"

