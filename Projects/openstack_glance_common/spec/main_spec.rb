require './.spec_helper'

describe ("check necessary packages are installed") do
  packages = ["openstack-glance", "python-memcached"]
  packages.each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end
