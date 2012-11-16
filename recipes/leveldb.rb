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
  package "libleveldb1"
  package "python-leveldb"
end

if platform?("ubuntu")
  package "libleveldb-dev"
  package "python-leveldb"
end

node.default['electrum']['conf']['leveldb']['path'] = "/var/db/leveldb"

include_recipe "electrum::server"

