# This file is only used when running chef in local mode during image creation
# cd /home/vagrant/cookbooks/custom_haproxy && sudo chef-client -z -c client.rb -o custom_haproxy
cookbook_path '/home/vagrant/cookbooks'
local_mode 'true'
log_level :info
