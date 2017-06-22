require './.spec_helper'

describe ("my_jenkins") do
  describe ("check packages are installed") do
    pkgs = ["docker-ce", "sshpass"]
    pkgs.each do |pkg|
      describe package(pkg) do
        it { should be_installed }
      end
    end
  end

  describe ("check jq version") do
    describe command("jq --version") do
      its(:stdout) { should match /^jq-#{ property['args']['JQ_VER'] }$/}
    end
  end

  describe ("check docker-compose version") do
    describe command("docker-compose -v") do
      its(:stdout) { should match /^docker-compose version #{ property['args']['DOCKER_COMPOSE_VER'] },.*$/ }
    end 
  end

  describe ("check environtment var TZ = #{ property['args']['SET_TZ'] } ") do
    describe command("env | grep TZ") do
      its(:stdout) { should match /^TZ=#{ Regexp.escape(property['args']['SET_TZ']) }$/ }
    end
  end

end

