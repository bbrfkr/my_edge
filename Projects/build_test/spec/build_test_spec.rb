require './.spec_helper'

describe ("build_test") do
  describe ("check pip packages are installed") do
    pips = ["ansible"]
    describe command("source /root/.bash_profile && pip list") do
      pips.each do |pip|
        describe ("#{ pip }") do
          pip_ver = property['args'][pip.upcase.gsub("-","_") + '_VER']
          if pip_ver != nil
            its(:stdout) { should match /^#{ pip }\s(.*#{ Regexp.escape(pip_ver) }.*)$/ }
          else
            its(:stdout) { should match /^#{ pip }\s(.*)$/ }
          end
        end
      end
    end
  end

  describe ("check gem packages are installed") do
    gems = ["itamae", "serverspec", "infrataster", "docker-api", "inifile", "activesupport"]
    describe command("source /root/.bash_profile && gem list") do
      gems.each do |gem|
        describe ("#{ gem }") do
          gem_ver = property['args'][gem.upcase.gsub("-","_") + '_VER']
          if gem_ver != nil
            its(:stdout) { should match /^#{ gem }\s(.*#{ Regexp.escape(gem_ver) }.*)$/ }
          else
            its(:stdout) { should match /^#{ gem }\s(.*)$/ }
          end
        end
      end
    end
  end

  describe ("check ruby version") do
    describe command("source /root/.bash_profile && rbenv version") do
      its(:stdout) { should match /^#{ property['args']['RUBY_VER'] }\s/ }
    end
  end

  describe ("check rpm packages are installed") do
    pkgs = ["docker", "openssh-server"]
    pkgs.each do |pkg|
      describe package(pkg) do
        it { should be_installed }
      end
    end
  end

  describe ("check docker-compose version") do
    describe command("source /root/.bash_profile && docker-compose -v") do
      its(:stdout) { should match /^docker-compose version #{ property['args']['DOCKER_COMPOSE_VER'] },.*$/ }
    end
  end
end
