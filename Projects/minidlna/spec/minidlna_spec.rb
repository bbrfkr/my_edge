require './.spec_helper'

describe ("minidlna") do
  describe ("check minidlna package is installed") do
    describe package("minidlna") do
      it { should be_installed }
    end
  end

  describe ("check minidlna service is started") do
    describe service("minidlna") do
      it { should be_running }
    end
  end

  describe ("check media_dir parameter is specified") do
    describe file("/etc/minidlna.conf") do
      its(:content) { should match /^media_dir=#{property['args']['MEDIA_DIR']}$/ }
    end
  end
end

