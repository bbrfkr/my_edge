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
