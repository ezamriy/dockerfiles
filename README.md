# centos-5-vagrant-supervisor-ssh

CentOS 5 vagrant friendly container with supervisord and sshd installed.

## Installation

You may fetch the pre-built image from Docker Hub:

`$ docker pull ezamriy/centos-5-vagrant-supervisor-ssh`

Minimal Vagrantfile example:

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.provider "docker" do |docker|
      docker.image = "ezamriy/centos-5-vagrant-supervisor-ssh"
      docker.has_ssh = true
  end
end
```

Please check [Vagrant documentation](https://www.vagrantup.com/docs/docker/) to get more information.
