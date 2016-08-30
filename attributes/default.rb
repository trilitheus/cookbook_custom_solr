default['custom_solr']['java_xmx'] = (node['memory']['total'].to_i * 3 / 8).floor
default['custom_solr']['java_xms'] = (node['memory']['total'].to_i * 3 / 8).floor
