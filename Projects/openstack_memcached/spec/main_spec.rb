require './.spec_helper'

describe ("check necessary packages are installed") do
  packages = ["memcached", "python-memcached"]
  packages.each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end

describe ("check listen ip 0.0.0.0 is registered") do
  describe file("/etc/sysconfig/memcached") do
    its(:content) { should match /OPTIONS="-l 0.0.0.0"/ }
  end
end

describe ("check memcached process is running") do
  describe process("memcached") do 
    it { should be_running }
  end
end
