bash "setup apt" do
  user "root"
  group "root"
  cwd "/usr/local/src"
  code <<-EOC
    apt-get install aptitude
    add-apt-repository ppa:ubuntu-elisp/ppa -y
    add-apt-repository ppa:chris-lea/node.js -y
    dpkg --configure -a
    apt-get update
    gem install rake
  EOC
end

%w{lubuntu-desktop zsh autotools-dev automake libtool
  libevent-dev zlib1g-dev libbz2-dev libyaml-dev
  libxml2-dev libxslt1-dev libreadline-dev xclip patch libmysqlclient-dev
  chromium-browser ibus-mozc mozc-server mozc-utils-gui emacs-mozc emacs-mozc-bin
  emacs24 emacs24-el xfonts-shinonome python-xlib
  libterm-readkey-perl g++ ant subversion libpcre3-dev  libidn11-dev ssh
  sendmail expect python-software-properties gettext tcl tk
  libsvn-perl asciidoc libcurl4-gnutls-dev libcurl4-openssl-dev curl
  libexpat-dev zlib1g-dev libbz2-dev python-appindicator redis-server
  nodejs markdown ack-grep ntp qtcreator xvfb qt4-dev-tools libqt5webkit5-dev
  qtquick1-5-dev qtlocation5-dev libqt5sensors5-dev qtdeclarative5-dev
  libgio2.0-cil-dev rpm2cpio libsqlite3-dev libgstreamer1.0-dev libgstreamer0.10-dev
  libgstreamer-plugins-base1.0-dev libgstreamer-plugins-base0.10-dev meld
  irb jq python-pip pepperflashplugin-nonfree libpq-dev gccgo-go git}.each do |pkg|
  package pkg do
     action :install
  end
end

#template "/etc/X11/xorg.conf" do
#  source "xorg.conf.erb"
#  owner "root"
#  group "root"
#  mode 00644
#end

bash "set hostname" do
  user "root"
  cwd "/etc"
  code <<-EOC
    echo #{node['devenv']['hostname']} > hostname
  EOC
end

service "ntp" do
  service_name "ntp"
  restart_command "/etc/init.d/ntp restart"
  supports [:restart]
  action :enable
end

template "/etc/ntp.conf" do
  source "ntp.conf.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, "service[ntp]"
end

# make user
user node['dev_user']['id'] do
  home "/home/#{node['dev_user']['id']}"
  shell node['dev_user']['shell']
  password node['dev_user']['password']
end

directory "/home/#{node['dev_user']['id']}" do
  owner node['dev_user']['id']
  group node['dev_user']['id']
  action :create
end

include_recipe 'docker'

bash "add groups" do
  user "root"
  cwd "/usr/local/src"
  code <<-EOC
    gpasswd -a #{node['dev_user']['id']} sudo
    gpasswd -a #{node['dev_user']['id']} vboxsf
    gpasswd -a #{node['dev_user']['id']} docker
  EOC
end

%w{global tmux ncftp tig updatedb the_silver_searcher
  ruby_build rbenv::user golang::packages timezone}.each do |cookbook|
  include_recipe cookbook
end

bash 'homesick' do
  user node['dev_user']['id']
  cwd "/home/#{node['dev_user]['id']}"
  code <<-EOC
    gem install homesick
    rbenv rehash
    homesick clone https://github.com/muratayusuke/dotfiles.git
    homesick symlink
  EOC
end
