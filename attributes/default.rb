default['devenv']['hostname'] = 'dummy.hostname.com'
default['dev_user']['id'] = 'devuser'
default['dev_user']['shell'] = '/bin/zsh'
default['dev_user']['password'] = '$1$SSk7c5ij$JggO4l1XCuWAKFLMveQoK.' # devuser

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

# golang for hub
default['go']['packages'] = ['encoding']
