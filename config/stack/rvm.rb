package :rvm do
	description 'RVM - Ruby Version Manager'
	version 'head :)'
	source "http://github.com/wayneeseguin/rvm/tarball/0.1.40" do
		custom_archive 'wayneeseguin-rvm-0.1.40-0-gdc66677.tar.gz'
		custom_dir 'wayneeseguin-rvm-dc66677'
		custom_install 'sudo ./install'
	end
	rvm_config = <<-EOS
	if [ -s "$HOME/.rvm/scripts/rvm" ] ; then
		. "$HOME/.rvm/scripts/rvm"
	elif [ -s "/usr/local/rvm/scripts/rvm" ] ; then
		. "/usr/local/rvm/scripts/rvm"
	fi
	EOS
	push_text "export rvm_path=/usr/local/rvm", '/etc/rvmrc', :sudo => true
	rvm_config.each_line do |line|
		push_text "#{line}", '/etc/profile', :sudo => true
	end
	post :install, 'sudo groupadd rvm', 'sudo chown -R root:rvm /usr/local/rvm', 'sudo chmod g+rw /usr/local/rvm'
	verify do
		has_file '/etc/rvmrc'
	end
	requires :rvm_dependencies
end

package :rvm_dependencies do
	apt %w(zlib1g-dev libssl-dev libreadline5-dev libxml2-dev)
	requires :build_essential
end
