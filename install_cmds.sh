export PATH=$PATH:/opt/chef/embedded/bin/
cd /tmp/devenv
berks vendor /etc/chef/cookbooks/
chef-solo
