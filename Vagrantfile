# Run with vagrant up

Vagrant.configure("2") do |config|
	config.vm.box = "precise32"
	config.vm.box_url = "http://files.vagrantup.com/precise32.box"
	config.vm.network :forwarded_port, host: 4000, guest: 4000
	config.vm.provision :shell,
		:inline => "sudo docker build -t adrian.arroyocalle/jekyll . && sudo docker run -d adrian.arroyocalle/jekyll"
end
