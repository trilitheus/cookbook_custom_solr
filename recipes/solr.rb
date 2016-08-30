group 'solr' do
  gid 6001
end

user 'solr' do
  uid 6001
  group 'solr'
  shell '/sbin/nologin'
end

# Solr requires lsof to check listening ports
package 'lsof'

tmp_dir = Chef::Config['file_cache_path']
file = 'solr-' + node['custom_solr']['version']
archive = file + '.tgz'

remote_file tmp_dir + '/' + archive do
  source node['custom_solr']['url'] + '/' + archive
  action :create_if_missing
end

bash "tar xzf #{tmp_dir}/#{archive}" do
  cwd '/opt'
  code <<-EOH
    tar xzf #{tmp_dir}/#{archive}
  EOH
  not_if { ::File.exist?("/opt/#{file}") }
end

link '/opt/solr' do
  to "/opt/#{file}"
end

cookbook_file tmp_dir + '/collection1.tgz'

bash "tar xzf #{tmp_dir}/collection1.tgz" do
  cwd '/opt/solr/server/solr'
  code <<-EOH
    tar xzf #{tmp_dir}/collection1.tgz
  EOH
  not_if { ::File.exist?('/opt/solr/server/solr/collection1') }
end

%w(solrconfig.xml schema.xml).each do |tmpl|
  template "/opt/solr/server/solr/collection1/conf/#{tmpl}" do
    user 'solr'
    group 'solr'
    notifies :run, 'bash[restart_solr]', :delayed
  end
end

bash "chown -R solr:solr /opt/#{file}" do
  code <<-EOH
    chown -R solr:solr /opt/#{file}
  EOH
  not_if { ::File.stat('/opt/solr/bin/solr').uid == 6001 }
end

monit_check 'solr' do
  check_id '/opt/solr/bin/solr-9084.pid'
  start_as 'solr'
  start_as_group 'solr'
  start '/opt/solr/bin/solr start -p 9084 -m 1536m'
  stop '/opt/solr/bin/solr stop'
end

bash 'restart_solr' do
  code <<-EOH
    monit restart solr
  EOH
  action :nothing
end
