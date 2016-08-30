#
# Cookbook Name:: custom_solr
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'custom_solr::default' do
  context 'When all attributes are default, on RHEL7' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node, server|
        node.automatic['memory']['total'] = 4096
      end.converge(described_recipe)
    end

    it 'includes the java default recipe' do
      expect(chef_run).to include_recipe('java::default')
    end
  end
end
