#
# Cookbook Name:: custom_solr
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'java::default'
include_recipe 'monit-ng::default'
include_recipe 'custom_solr::solr'
