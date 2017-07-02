require './.spec_helper'

describe ("check necessary packages are installed") do
  packages = ["mariadb", "mariadb-server", "python2-PyMySQL"]
  packages.each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end

describe ("check file openstack.cnf exists") do
  describe file("/etc/my.cnf.d/openstack.cnf") do
    it { should be_file }
  end
end

describe ("check process mysqld is running") do
  before :all do
    sleep 20 
  end
  describe process("mysqld") do
    it { should be_running }
  end
end

describe ("check mariadb root user is protected with password") do
  describe command("mysql -uroot -e \"show databases;\"") do
    its(:stderr) { should match /Access denied for user 'root'@'localhost' \(using password: NO\)/ }
  end
end

describe ("check root user can be logined from any other hosts") do
  describe command("mysql -uroot -ppassword -e \"show grants for root@'%'\"") do
    its(:stdout) { should match /GRANT ALL PRIVILEGES ON \*\.\* TO 'root'@'%' IDENTIFIED BY PASSWORD '.*' WITH GRANT OPTION/ }
  end
end
