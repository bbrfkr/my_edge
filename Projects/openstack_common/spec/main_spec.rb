require './.spec_helper'

describe ("check openstack repostiory is registered") do
  describe package("centos-release-openstack-ocata") do
    it { should be_installed }
  end
end

describe ("check packages are latest") do
  describe command("yum update --assumeno") do
    its(:stdout) { should match /No packages marked for update/ }
  end
end

describe ("check necessary packages are installed") do
  packages = ["python-openstackclient", "openstack-selinux"]
  packages.each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end

describe ("check env TZ equals 'Asia/Tokyo'") do
  describe command("env") do
    its(:stdout) { should match /^TZ=Asia\/Tokyo$/ }
  end
end
