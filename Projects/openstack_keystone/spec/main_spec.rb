require './.spec_helper'

mariadb_ip = `docker inspect test_mariadb | jq '.[].NetworkSettings.Networks.bridge.IPAddress'`
mariadb_ip.gsub!(/"/, "").chomp!

describe ("check necessary packages are installed") do
  packages = ["openstack-keystone", "httpd", "mod_wsgi"]
  packages.each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end

describe ("check keystone database is created") do
  before :all do
    sleep 60 
  end
  describe command("mysql -uroot -ppassword -h#{ mariadb_ip } -e 'show databases;'") do
    its(:stdout) { should match /keystone/ }
  end
end

describe ("check keystone db user is created") do
  describe command("mysql -uroot -ppassword -h#{ mariadb_ip } -e \"show grants for 'keystone'@localhost;\"") do
    its(:stdout) { should match /GRANT ALL PRIVILEGES ON `keystone`\.\* TO 'keystone'@'localhost'/ }
  end
  describe command("mysql -uroot -ppassword -h#{ mariadb_ip } -e \"show grants for 'keystone'@'%';\"") do
    its(:stdout) { should match /GRANT ALL PRIVILEGES ON `keystone`\.\* TO 'keystone'@'%'/ }
  end
end

describe ("check keystone database is configureed") do
  describe command("mysql -uroot -ppassword -h#{ mariadb_ip } keystone -e \"show tables;\"") do
    its(:stdout) { should match /Tables_in_keystone/ }
  end
end

describe ("check keystone fernet setup is completed") do
  describe file("/etc/keystone/fernet-keys") do
    it { should be_directory }
  end
end

describe ("check keystone credential setup is completed") do
  describe file("/etc/keystone/credential-keys") do
    it { should be_directory }
  end
end

describe ("check link wsgi-keystone.conf is created") do
  describe file("/etc/httpd/conf.d/wsgi-keystone.conf") do 
    it { should be_linked_to '/usr/share/keystone/wsgi-keystone.conf' }
  end
end

describe ("check httpd process is enabled") do
  describe process("httpd") do
    it { should be_running }
  end
end

describe ("check admin project is created") do
  describe command("unset http_proxy HTTP_PROXY && openstack project list") do
    its(:stdout) { should match /admin/ }
  end
end

describe ("check service project is created") do
  describe command("unset http_proxy HTTP_PROXY && openstack project list") do
    its(:stdout) { should match /service/ }
  end
end

describe ("check user role is created") do
  describe command("unset http_proxy HTTP_PROXY && openstack role list") do
    its(:stdout) { should match /user/ }
  end
end

describe ("check admin_token entry doesn't have /etc/keystone/keystone-paste.ini") do
  describe command("grep \" admin_token_auth \" /etc/keystone/keystone-paste.ini") do
    its(:stdout) { should match /^$/ }
  end
end

