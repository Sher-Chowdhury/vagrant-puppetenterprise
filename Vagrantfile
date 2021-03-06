# -*- mode: ruby -*-
# vi: set ft=ruby :


# http://stackoverflow.com/questions/19492738/demand-a-vagrant-plugin-within-the-vagrantfile
required_plugins = %w( vagrant-hosts vagrant-share vagrant-vbguest vagrant-vbox-snapshot vagrant-host-shell vagrant-triggers vagrant-reload )
plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end



Vagrant.configure(2) do |config|
  ##
  ##  puppet4ent
  ##
  # The "puppet4ent" string is the name of the box. hence you can do "vagrant up puppet4444ent"
  config.vm.define "puppet4ent" do |puppet4ent_config|
    puppet4ent_config.vm.box = "centos/7"

    # this set's the machine's hostname.
    puppet4ent_config.vm.hostname = "puppetent.local"


    # This will appear when you do "ip addr show". You can then access your guest machine's website using "http://192.168.60.4"
    puppet4ent_config.vm.network "private_network", ip: "192.168.60.100"
    # note: this approach assigns a reserved internal ip addresses, which virtualbox's builtin router then reroutes the traffic to,
    #see: https://en.wikipedia.org/wiki/Private_network

    puppet4ent_config.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      vb.gui = false
      # For common vm settings, e.g. setting ram and cpu we use:
      vb.memory = "2048"
      vb.cpus = 2
      # However for more obscure virtualbox specific settings we fall back to virtualbox's "modifyvm" command:
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      # name of machine that appears on the vb console and vb consoles title.
      vb.name = "puppet4ent"
    end

    config.vm.provision "file", source: "~/.gitconfig", destination: ".gitconfig"
    config.vm.provision "file", source: "files/pe.conf", destination: "/tmp/pe.conf"

    ## Copy the public+private keys from the host machine to the guest machine
    puppet4ent_config.vm.provision :host_shell do |host_shell|
      host_shell.inline = "[ -f ${HOME}/.ssh/id_rsa ] && cp -f ${HOME}/.ssh/id_rsa* ./personal-data/"
    end
    puppet4ent_config.vm.provision "shell", path: "scripts/import-ssh-keys.sh"

    puppet4ent_config.vm.provision "shell", path: "scripts/install-puppet4ent.sh"
    puppet4ent_config.vm.provision "shell", path: "scripts/update-git.sh"
    puppet4ent_config.vm.provision "shell", path: "scripts/install-vim-puppet-plugins.sh", privileged: false
    # for some reason I have to restart network, but this needs more investigation
#    puppet4ent_config.vm.provision "shell" do |remote_shell|
#      remote_shell.inline = "systemctl restart network"
#    end

    # this takes a vm snapshot (which we have called "basline") as the last step of "vagrant up".
    puppet4ent_config.vm.provision :host_shell do |host_shell|
      host_shell.inline = 'vagrant snapshot take puppet4ent baseline'
    end

  end

  ##
  ## Puppet agents - linux 7 boxes
  ##
  (1..1).each do |i|
    config.vm.define "puppet4agent0#{i}" do |puppet4agent_config|
      puppet4agent_config.vm.box = "centos/7"
      puppet4agent_config.vm.hostname = "puppetagent0#{i}.local"
      puppet4agent_config.vm.network "private_network", ip: "192.168.60.10#{i}"
      puppet4agent_config.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.memory = "1024"
        vb.cpus = 1
        vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
        vb.name = "puppet4agent0#{i}"
      end

      # for some reason I have to restart network, but this needs more investigation
      puppet4agent_config.vm.provision "shell" do |remote_shell|
        remote_shell.inline = "systemctl restart network"
      end

      puppet4agent_config.vm.provision "shell", path: "scripts/install-puppet4-agent.sh"

      # this takes a vm snapshot (which we have called "basline") as the last step of "vagrant up".
      puppet4agent_config.vm.provision :host_shell do |host_shell|
        host_shell.inline = "vagrant snapshot take puppet4agent0#{i} baseline"
      end

    end
  end

  # this line relates to the vagrant-hosts plugin, https://github.com/oscar-stack/vagrant-hosts
  # it adds entry to the /etc/hosts file.
  # this block is placed outside the define blocks so that it gts applied to all VMs that are defined in this vagrantfile.
  config.vm.provision :hosts do |provisioner|
    provisioner.add_host '192.168.60.100', ['puppetent', 'puppetent.local']
    provisioner.add_host '192.168.60.101', ['puppetagent01', 'puppetagent01.local']
    provisioner.add_host '192.168.60.102', ['puppetagent02', 'puppetagent02.local']
  end

  config.vm.provision :host_shell do |host_shell|
    host_shell.inline = 'hostfile=/etc/hosts && grep -q 192.168.60.100 $hostfile || echo "192.168.60.100   puppet4ent puppet4ent.local" >> $hostfile'
  end

  config.vm.provision :host_shell do |host_shell|
    host_shell.inline = 'hostfile=/etc/hosts && grep -q 192.168.60.101 $hostfile || echo "192.168.60.101   puppet4agent01 puppet4agent01.local" >> $hostfile'
  end

  config.vm.provision :host_shell do |host_shell|
    host_shell.inline = 'hostfile=/etc/hosts && grep -q 192.168.60.102 $hostfile || echo "192.168.60.102   puppet4agent02 puppet4agent02.local" >> $hostfile'
  end
end
