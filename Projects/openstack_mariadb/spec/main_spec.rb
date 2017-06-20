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
  describe process("mysqld") do
    it { should be_running }
  end
end
