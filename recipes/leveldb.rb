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
  if platform_version =~ /squeeze/
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

node.default['electrum']['conf']['leveldb']['path'] = "/var/db/leveldb"

include_recipe "electrum::server"

