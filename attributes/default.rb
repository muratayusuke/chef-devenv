default['devenv']['hostname'] = 'dummy.hostname.com'
default['dev_user']['id'] = 'devuser'
default['dev_user']['shell'] = '/bin/zsh'
default['dev_user']['password'] = '$1$SSk7c5ij$JggO4l1XCuWAKFLMveQoK.' # devuser

default['git']['version'] = '2.0.3'
default['the_silver_searcher']['version'] = '8cd9dd942d8ebe5c0b0b4593a9d64ae42fb07684'
default['the_silver_searcher']['url'] = "https://github.com/byplayer/the_silver_searcher/archive/#{node['the_silver_searcher']['version']}.tar.gz"
default['tmux']['install_method'] = 'source'
default['tmux']['version'] = '1.9'

# rbenv
default['rbenv']['user_installs'] = [
  { 'user' => node['dev_user']['id'],
    'rubies' => ['2.1.2'],
    'global' => '2.1.2',
    'gems' => {
      '2.1.2' => [
        { 'name' => 'bundler' }
      ]
    }
  }
]

# timezone
default[:tz] = 'Asia/Tokyo'
