vagrant-puppetmaster4

### Overview

The vagrant project is a 3 Centos7 vm development environment, i.e.:  

```
$ vagrant status
Current machine states:

puppetmaster            not created (virtualbox)
puppetagent01           not created (virtualbox)
puppetagent02           not created (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

Here we have the puppetmaster vm, this has the free version of puppetmaster installed on it. puppetagent01 and puppetagent02 only have the puppet agent installed on them.


### Pre-reqs

you need to have the following installed on your host machine:

* [virtualbox](https://www.virtualbox.org/)  
* [vagrant](https://www.vagrantup.com/)

Once they are all installed, do the following (not required for macs):

1. right click on the virtualbox icon,
2. go to properties,
3. select the shortcut tab
4. click on the "advanced" button
5. enable the "Run as Administrator" checkbox
6. Then apply and save changes
7. Repeat the above steps, but this time for Git bash, You can find this icon under, start -> All programs -> git -> Git Bash


### Pre-reqs (optional, but recommended)


On your (linux, e.g. Apple MacBook) host machine, create the following folder and add the following files:

```
$ ls -l /c/vagrant-personal-files/
total 1
-rw-r--r--    1 SChowdhu Administ      210 Apr 20  2015 hiera.yaml
-rw-r--r--    1 SChowdhu Administ      291 Sep 30 08:52 r10k.yaml
```

However if your host machine is a windows machine, then create folder "C:\vagrant-personal-files" and place the above files in there instead.


### Set up

Start a bash terminal

cd into the project folder and run the following:


```sh
$ vagrant up puppet4master
```

This will take about 20 minutes to complete, but depends on your machine specs and internet connections.



There are also 2 ansible CentOS 7 clients that you can start up:


```sh
$ vagrant up puppet4agent01
$ vagrant up puppet4agent02
```



### Set up local rerouting if you are running vagrant on windows machine

Enter this in the windows hosts file (C:\Windows\System32\drivers\etc\hosts), or /etc/hosts file if your using an Apple Mac:

```
# https://github.com/Sher-Chowdhury/vagrant-puppetmaster4
192.168.50.100   puppetmaster puppetmaster.local
192.168.50.101   puppetagent01 puppetagent01.local
192.168.50.102   puppetagent02 puppetagent02.local
```

### Login credentials
you can ssh into all your machines using the following credential:

```
username: vagrant
password: vagrant
```

Therefore you can do (using puppetmaster.local as an example):

```sh
$ ssh vagrant@puppetmaster.local
```

You can also log in using the following credentials:

```
username: root
password: vagrant
```

Note, it is common practice to login as the vagrant user, then do 'sudo -i' to become root.


If you want to login as the vagrant user, then you can do it with the following shorthand technique (using puppet4master as an example):

```sh
$ vagrant ssh puppet4master
```

This approach is handy in case you didn't know what the vagrant user's password is.



### Auto snapshots

On accasions you'll want to reset your vagrant boxes. This is usually done by doing "vagrant destroy" followed by "vagrant up". This can be timeconsuming. A much faster approach is to use virtualbox snapshots instead.


For each vm, a virtualbox is taken towards the end of your "vagrant up". This snapshot is called "baseline". If you want to roll back to this snapshot, then you do:

```sh
$ vagrant snapshot go puppetmaster baseline
```

...or for an ansible client, e.g. puppetagent01, you do:

```sh
$ vagrant snapshot go puppetagent01 baseline
```

### Start all over again
If you want to start from the begining again, then do:

```sh
$ vagrant destroy
$ vagrant box list
$ vagrant box remove {box name}
```
