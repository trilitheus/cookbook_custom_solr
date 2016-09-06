#
# Cookbook Name:: custom_solr
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'custom_solr::solr' do
  context 'When all attributes are default, on RHEL7' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(file_cache_path: '/tmp') do |node|
        node.automatic['memory']['total'] = 4096
        node.automatic['os'] = 'linux'
        node.automatic['platform_family'] = 'rhel'
      end.converge(described_recipe)
    end

    solr_version = '5.5.2'

    it 'creates the solr group' do
      expect(chef_run).to create_group('solr').with_gid(6001)
    end

    it 'creates the solr user' do
      expect(chef_run).to create_user('solr').with_uid(6001)
    end

    it 'install lsof' do
      expect(chef_run).to install_package('lsof')
    end

    it 'downloads the solr tgz file' do
      expect(chef_run).to create_remote_file_if_missing("/tmp/solr-#{solr_version}.tgz")
    end

    it 'unpacks the solr_archive' do
      expect(chef_run).to run_bash("tar xzf /tmp/solr-#{solr_version}.tgz").with_cwd('/opt')
    end

    it 'links the solr versioned dir to non versioned' do
      expect(chef_run).to create_link('/opt/solr').with(to: "/opt/solr-#{solr_version}")
    end

    it 'adds the collection1 tar file' do
      expect(chef_run).to render_file('/tmp/collection1.tgz')
    end

    it 'unpacks the collection1 core' do
      expect(chef_run).to run_bash('tar xzf /tmp/collection1.tgz').with_cwd('/opt/solr/server/solr')
    end

    it 'renders the solr config and schema templates' do
      expect(chef_run).to render_file('/opt/solr/server/solr/collection1/conf/schema.xml')
      expect(chef_run).to render_file('/opt/solr/server/solr/collection1/conf/solrconfig.xml')
    end

    it 'changes ownership of the solr directory' do
      expect(chef_run).to run_bash("chown -R solr:solr /opt/solr-#{solr_version}")
    end

    it 'adds monit service for solr' do
      expect(chef_run).to create_monit_check('solr')
    end
  end
end
