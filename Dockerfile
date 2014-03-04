FROM muratayusuke/chef-solo-berkshelf3

ENV LANG C.UTF-8

RUN mkdir -p /tmp/devenv
ADD ./solo.rb /etc/chef/solo.rb
ADD ./node.json /etc/chef/node.json
ADD ./Berksfile /tmp/devenv/Berksfile
ADD ./attributes /tmp/devenv/attributes
ADD ./recipes /tmp/devenv/recipes
ADD ./install_cmds.sh /tmp/devenv/install_cmds.sh
ADD ./metadata.rb /tmp/devenv/metadata.rb
ADD ./README.md /tmp/devenv/README.md
RUN /tmp/devenv/install_cmds.sh