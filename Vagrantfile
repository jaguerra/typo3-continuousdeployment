Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.ssh.forward_agent = true
  #config.vm.synced_folder "./", "/var/www", id: "vagrant-root" 

	config.vm.define :web do |web|
			web.vm.network :private_network, ip: "192.168.56.103"

			web.vm.provider :virtualbox do |v|
    			v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    			v.customize ["modifyvm", :id, "--memory", 1024]
    			v.customize ["modifyvm", :id, "--name", "typo3cdweb"]
  		end

			web.vm.provision :puppet do |puppet|
    			puppet.manifests_path = "manifests"
    			puppet.module_path = "modules"
    			puppet.options = ['--verbose']
  		end
  end

	config.vm.define :ci do |ci|
			ci.vm.network :private_network, ip: "192.168.56.104"

			ci.vm.provider :virtualbox do |v|
    			v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    			v.customize ["modifyvm", :id, "--memory", 1024]
    			v.customize ["modifyvm", :id, "--name", "typo3cdci"]
  		end

			ci.vm.provision :puppet do |puppet|
					puppet.manifest_file = "jenkins.pp"
    			puppet.manifests_path = "manifests"
    			puppet.module_path = "modules"
    			puppet.options = ['--verbose']
  		end
  end
end
