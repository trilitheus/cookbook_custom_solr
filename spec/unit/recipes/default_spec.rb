#
# Cookbook Name:: custom_solr
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'custom_solr::default' do
  context 'When all attributes are default, on RHEL7' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(file_cache_path: '/tmp') do |node|
        node.automatic['memory']['total'] = 4096
      end.converge(described_recipe)
    end

    it 'includes the java default recipe' do
      expect(chef_run).to include_recipe('java::default')
    end

    it 'includes the monit-ng default recipe' do
      expect(chef_run).to include_recipe('monit-ng::default')
    end

    it 'includes the solr recipe' do
      expect(chef_run).to include_recipe('custom_solr::solr')
    end
  end
end
