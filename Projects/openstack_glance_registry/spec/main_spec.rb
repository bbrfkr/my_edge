require './.spec_helper'

describe ("check glance-registry process is started") do
  describe process("glance-registry") do
    it { should be_running }
  end
end

