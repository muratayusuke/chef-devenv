%w{docker git global tmux ncftp tig updatedb}.each do |cookbook|
  include_recipe cookbook
end

bash "setup apt" do
  user "root"
  group "root"
  cwd "/usr/local/src"
  code <<-EOC
    apt-get install aptitude
    add-apt-repository ppa:cassou/emacs
    add-apt-repository ppa:chris-lea/node.js
    apt-add-repository ppa:mizuno-as/silversearcher-ag
    apt-get update
  EOC
end

%w{lubuntu-desktop zsh autotools-dev automake libtool
  libevent-dev zlib1g-dev libbz2-dev libyaml-dev
  libxml2-dev libxslt1-dev libreadline-dev xsel patch libmysqlclient-dev
  chromium-browser ibus-mozc mozc-server mozc-utils-gui
  emacs24 emacs24-el xfonts-shinonome python-xlib
  libterm-readkey-perl g++ rubygems ant subversion libpcre3-dev  libidn11-dev ssh
  sendmail expect python-software-properties gettext tcl tk
  libsvn-perl asciidoc libcurl4-gnutls-dev libcurl4-openssl-dev curl
  libexpat-dev zlib1g-dev libbz2-dev python-appindicator redis-server
  nodejs markdown ack-grep ntp qtcreator xvfb qt4-dev-tools libqt5webkit5-dev
  qtquick1-5-dev qtlocation5-dev qtsensors5-dev qtdeclarative5-dev
  libgio2.0-cil-dev rpm2cpio libsqlite3-dev libgstreamer1.0-dev libgstreamer0.10-dev
  libgstreamer-plugins-base1.0-dev libgstreamer-plugins-base0.10-dev meld
  irb silversearcher-ag jq}.each do |pkg|
  package pkg do
     action :install
  end
end

template "/etc/X11/xorg.conf" do
  source "xorg.conf.erb"
  owner "root"
  group "root"
  mode 00644
end

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
