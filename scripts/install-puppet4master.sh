#!/bin/bash

echo '##########################################################################'
echo '##### About to run install-puppetmaster4.sh script #######################'
echo '##########################################################################'


yum install -y ruby-devel
yum install -y wget
yum install -y epel-release
yum install -y jq
yum install -y vim
yum install -y htop
yum install -y tree


cd /root

wget -O - https://downloads.puppetlabs.com/puppetlabs-gpg-signing-key.pub | gpg --import
curl -L -o pe-latest.tgz 'https://pm.puppetlabs.com/cgi-bin/download.cgi?dist=el&rel=7&arch=x86_64&ver=latest'

tar -xf pe-latest.tgz

wget https://gist.githubusercontent.com/Sher-Chowdhury/d402b0a1267cc6ae767b86b710ec4fe3/raw/86b0a4a78be833dc4eaf1a4c77fa4994b07945ef/pe.conf

cd /root/puppet-enterprise*



./puppet-enterprise-installer -c /root/pe.conf  > /root/pe-install-result.log

/opt/puppetlabs/bin/puppet agent -t
/opt/puppetlabs/bin/puppet agent -t

/opt/puppetlabs/bin/puppet module install puppet-zabbix

/opt/puppetlabs/bin/puppet agent -t

#rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm  || exit 1

#yum install -y puppetserver || exit 1


# https://docs.puppetlabs.com/puppetserver/latest/install_from_packages.html#memory-allocation
#sed -i s/^JAVA_ARGS/#JAVA_ARGS/g /etc/sysconfig/puppetserver || exit 1
#echo 'JAVA_ARGS="-Xms512m -Xmx512m -XX:MaxPermSize=256m"' >> /etc/sysconfig/puppetserver
#echo 'JAVA_ARGS="-Xms512m -Xmx512m"' >> /etc/sysconfig/puppetserver || exit 1


# http://docs.puppetlabs.com/puppet/4.3/reference/whered_it_go.html
#echo "PATH=$PATH:/opt/puppetlabs/bin" >> /root/.bashrc || exit 1
#PATH=$PATH:/opt/puppetlabs/bin || exit 1
#puppet --version || exit 1




# this is so to get the puppetmaster to autosign puppet agent certificicates.
# This means that you no longer need to do "puppet cert sign...etc"
# https://docs.puppetlabs.com/puppet/latest/reference/ssl_autosign.html#basic-autosigning-autosignconf
# https://docs.puppetlabs.com/puppet/latest/reference/config_file_autosign.html

#puppet config set autosign true --section master
# echo '*' >> /etc/puppet/autosign.conf   # this line needs fixing, see:
					  # https://docs.puppetlabs.com/puppet/latest/reference/config_file_autosign.html


##
## The following is a direct copy taken from puppet 3.8 config file. So need to investigate which parts I need.
##
## https://docs.puppetlabs.com/puppet/latest/reference/config_about_settings.html
## https://docs.puppetlabs.com/puppet/latest/reference/configuration.html
#fqdn=`hostnamectl | grep 'Static hostname' | cut -d':' -f2`

#puppet config set certname $fqdn --section agent
#puppet config set server $fqdn --section agent

#echo '    certname          = puppet4master.local' >> /etc/puppetlabs/puppet/puppet.conf
#echo '    server            = puppet4master.local' >> /etc/puppetlabs/puppet/puppet.conf

#systemctl enable puppetserver || exit 1
#systemctl start puppetserver  || exit 1
#systemctl restart puppetserver  || exit 1
#systemctl status puppetserver || exit 1
