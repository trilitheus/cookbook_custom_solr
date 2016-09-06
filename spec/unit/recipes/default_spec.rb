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
        node.automatic['os'] = 'linux'
        node.automatic['platform_family'] = 'rhel'
      end.converge(described_recipe)
    end

    it 'includes the java cookbook' do
      expect(chef_run).to include_recipe('java::default')
    end

    it 'includes the monit-ng cookbook' do
      expect(chef_run).to include_recipe('monit-ng::default')
    end

    it 'includes the custom_solr:solr recipe' do
      expect(chef_run).to include_recipe('custom_solr::solr')
    end
  end
end
