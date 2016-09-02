describe file('/opt/solr-5.5.2') do
  it { should be_directory }
end

describe file('/opt/solr') do
  it { should be_linked_to '/opt/solr-5.5.2' }
end

describe file('/opt/solr/server/solr/collection1/conf/schema.xml') do
  it { should be_file }
end

describe package('monit') do
  it { should be_installed }
end

describe file('/etc/monit.d/solr.conf') do
  it { should be_file }
end

describe port(9084) do
  it { should be_listening }
end
