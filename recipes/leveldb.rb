#
# Cookbook Name:: electrum-server
# Recipe:: leveldb storage
#
# Copyright (C) 2012 Casey Link <unnamedrambler@gmail.com>
# 
#
include_recipe "python::pip"
include_recipe "python::virtualenv"

# install dependencies

package "libleveldb1"
package "python-leveldb"

node.default['electrum']['conf']['leveldb']['path'] = "/var/db/leveldb"

include_recipe "electrum::server"

