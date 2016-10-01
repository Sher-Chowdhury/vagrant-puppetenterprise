#!/bin/bash
# this script is run on the agent only.

echo '##########################################################################'
echo '##### About to run install-puppet4-agent.sh script #######################'
echo '##########################################################################'

rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm || exit 1
yum install -y puppet-agent || exit 1


echo "PATH=$PATH:/opt/puppetlabs/bin" >> /root/.bashrc || exit 1
PATH=$PATH:/opt/puppetlabs/bin || exit 1


puppet config set --section agent server puppetmaster.local
puppet config set --section agent certname `hostname --fqdn`


ping -c 3 puppetmaster.local
if [ $? -eq 0 ]; then
  puppet agent -t  2>/dev/null
  puppet agent -t
fi
