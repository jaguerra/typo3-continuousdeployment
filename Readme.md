# "Setting up Continuous Delivery for your TYPO3 CMS projects"

This will setup a VM test environment for the workshop. We will end up
having:

* A LAMP web server to deploy the site
* A CI Server to play with

We'll use [Vagrant][1] to create the VMs. [Puppet][2] will be used to
manage the configuration inside each one.

## Prerequisites

* Install [VirtualBox][3] ( avoid 4.2.14 as it won't work on the latest
  Vagrant!! )
* Install [Vagrant][1]

## Launch the environment

	$ vagrant up

That will create, download and configure everything. Please note that
download may take 600-700Mb and then about 15 minutes to configure every
VM. So, sit down and relax :)


## Some conventions and undesired manual stuff

Networking configuration is preconfigured on the Vagrantfile:

* Web VM: IP 192.168.56.103
* CI: IP 192.168.56.104

You may need to add those entries on to your hosts file.


[1]: http://www.vagrantup.com/  "Vagrant"
[2]: https://puppetlabs.com/ "Puppet"
[3]: https://www.virtualbox.org/wiki/Download_Old_Builds_4_2  "VirtualBox"

