#
# Cookbook Name:: electrum-server
# Recipe:: abe storage
#
# Copyright (C) 2012 Casey Link <unnamedrambler@gmail.com>
#

# instal abe
include_recipe "bitcoin-abe"

#TODO: setup abe confs
#node.default["electrum"]["conf"] = ""

# setup server
include_recipe "electrum::server"
