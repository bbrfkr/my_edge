require './.spec_helper'

describe ("check necessary packages are installed") do
  describe package("rabbitmq-server") do
    it { should be_installed }
  end
end

describe ("check openstack user exists") do
  before :all do
    sleep 30
  end
  describe command("rabbitmqctl list_users") do
    its(:stdout) { should match /openstack/ }
  end
end

describe ("check permission is set for openstack user") do
  describe command("rabbitmqctl list_permissions | grep openstack") do
    its(:stdout) { should match /\.\*\s*\.\*\s*\.\*/ }
  end
end
