require './.spec_helper'

mariadb_ip = `docker inspect test_mariadb | jq '.[].NetworkSettings.Networks.bridge.IPAddress'`
mariadb_ip.gsub!(/"/, "").chomp!
keystone_ip = `docker inspect test_keystone | jq '.[].NetworkSettings.Networks.bridge.IPAddress'`
keystone_ip.gsub!(/"/, "").chomp!

describe ("check glance database is created") do
  before :all do
    sleep 40
  end
  describe command("mysql -uroot -ppassword -h#{ mariadb_ip } -e 'show databases;'") do
    its(:stdout) { should match /glance/ }
  end
end

describe ("check glance db user is created") do
  describe command("mysql -uroot -ppassword -h#{ mariadb_ip } -e \"show grants for 'glance'@localhost;\"") do
    its(:stdout) { should match /GRANT ALL PRIVILEGES ON `glance`\.\* TO 'glance'@'localhost'/ }
  end
  describe command("mysql -uroot -ppassword -h#{ mariadb_ip } -e \"show grants for 'glance'@'%';\"") do
    its(:stdout) { should match /GRANT ALL PRIVILEGES ON `glance`\.\* TO 'glance'@'%'/ }
  end
end

export_url = "export OS_AUTH_URL=http://#{ keystone_ip }:35357/v3"

describe ("check glance user is created") do
  before :all do
    sleep 45 
  end
  describe command("#{ export_url } && unset http_proxy HTTP_PROXY && openstack user list") do
    its(:stdout) { should match /glance/ }
  end
end

describe ("check glance user role is admin") do
  describe command("#{ export_url } && unset http_proxy HTTP_PROXY && openstack role list --project service --user glance") do
    its(:stdout) { should match /admin/ }
  end
end

describe ("check glance service is created") do
  describe command("#{ export_url } && unset http_proxy HTTP_PROXY && openstack service list") do
    its(:stdout) { should match /glance/ }
  end
end

describe ("check glance service endpoint is created") do
  describe command("#{ export_url } && unset http_proxy HTTP_PROXY && openstack endpoint list | grep glance") do
    its(:stdout) { should match /admin/ }
    its(:stdout) { should match /public/ }
    its(:stdout) { should match /internal/ }
  end
end

describe ("check glance-api process is started") do
  describe process("glance-api") do
    it { should be_running }
  end
end

describe ("check glance database is configureed") do
  describe command("mysql -uroot -ppassword -h#{ mariadb_ip } glance -e \"show tables;\"") do
    its(:stdout) { should match /Tables_in_glance/ }
  end
end
