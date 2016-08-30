override['java']['jdk_version'] = '8'

solr_version = '5.5.2'

default['custom_solr']['java_xmx'] = (node['memory']['total'].to_i * 3 / 8).floor
default['custom_solr']['java_xms'] = (node['memory']['total'].to_i * 3 / 8).floor

default['custom_solr']['version'] = solr_version
default['custom_solr']['url'] = "http://archive.apache.org/dist/lucene/solr/#{solr_version}"
