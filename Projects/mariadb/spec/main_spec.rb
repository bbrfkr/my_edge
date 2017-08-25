require './.spec_helper'

describe ("check necessary packages are installed") do
  packages = ["mariadb-server", "expect"]
  packages.each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end

describe ("check mysql_install_db is completed") do
  describe command("ls -1 /var/lib/mysql") do
    its(:stdout) { should_not match /^$/ }
  end
end

describe ("check mysqld daemon is started") do
  before :all do
    sleep 10
  end
  describe process("mysqld") do
    it { should be_running }
  end
end

describe ("check mariadb root password is set") do
  describe command("mysql -uroot -e 'show databases;'") do
    its(:stderr) { should match /^ERROR/ }
  end
end
