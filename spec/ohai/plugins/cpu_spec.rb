#
# Author:: Franklin Webber (<franklin.webber@gmail.com>)
# Copyright:: Copyright (c) 2019 Franklin Webber
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

describe_ohai_plugin :CPU do
  let(:plugin_file) { 'cpu' }

  it 'provides attribute: cpu' do
    expect(plugin).to provide_attribute('cpu')
  end

  context 'windows' do
    let(:platform) { 'windows' }

    let(:cpu_data) do
      <<~CPU
        CPU0,Description,String,Intel64 Family 6 Model 63 Stepping 2
        CPU0,DeviceID,String,CPU0
        CPU0,Family,UInt32,5
        CPU0,Name,String,Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz
        CPU0,L2CacheSize,UInt32,0
        CPU0,MaxClockSpeed,UInt32,2400
        CPU0,NumberOfCores,UInt32,1
        CPU0,NumberOfLogicalProcessors,UInt32,1
        CPU0,Manufacturer,String,GenuineIntel
        CPU0,Revision,UInt32,16130
      CPU
    end

    before :each do
      allow(plugin).to receive(:cpu_data).and_return(cpu_data)
    end

    it 'cpu/0/core' do
      expect(plugin_attribute('cpu/0/cores')).to eq(1)
    end

    it 'cpu/0/vendor_id' do
      expect(plugin_attribute('cpu/0/vendor_id')).to eq('GenuineIntel')
    end

    it 'cpu/0/family' do
      expect(plugin_attribute('cpu/0/family')).to eq(5)
    end

    it 'cpu/0/model' do
      expect(plugin_attribute('cpu/0/model')).to eq(16130)
    end

    it 'cpu/0/physical_id' do
      expect(plugin_attribute('cpu/0/physical_id')).to eq("CPU0")
    end

    it 'cpu/0/model_name' do
      expect(plugin_attribute('cpu/0/model_name')).to eq("Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz")
    end

    it 'cpu/0/description' do
      expect(plugin_attribute('cpu/0/description')).to eq("Intel64 Family 6 Model 63 Stepping 2")
    end

    it 'cpu/0/mhz' do
      expect(plugin_attribute('cpu/0/mhz')).to eq(2400)
    end

    it 'cpu/0/cache_size' do
      expect(plugin_attribute('cpu/0/cache_size')).to eq('0kB')
    end

    it 'cpu/0/stepping' do
      expect(plugin_attribute('cpu/0/stepping')).to eq('2')
    end

    it 'cpu/total' do
      expect(plugin_attribute('cpu/total')).to eq(1)
    end

    it 'cpu/cores' do
      expect(plugin_attribute('cpu/cores')).to eq(1)
    end

    it 'cpu/real' do
      expect(plugin_attribute('cpu/real')).to eq(1)
    end
  end
end

# shared_examples "a cpu" do |cpu_no|
#   describe "cpu #{cpu_no}" do
#     it "should set physical_id to CPU#{cpu_no}" do
#       expect(@plugin[:cpu][cpu_no.to_s][:physical_id]).to eq("CPU#{cpu_no}")
#     end

#     it "should set mhz to 2793" do
#       expect(@plugin[:cpu][cpu_no.to_s][:mhz]).to eq("2793")
#     end

#     it "should set vendor_id to GenuineIntel" do
#       expect(@plugin[:cpu][cpu_no.to_s][:vendor_id]).to eq("GenuineIntel")
#     end

#     it "should set model_name to Intel(R) Core(TM) i7-4500U CPU @ 1.80GHz" do
#       expect(@plugin[:cpu][cpu_no.to_s][:model_name])
#         .to eq("Intel(R) Core(TM) i7-4500U CPU @ 1.80GHz")
#     end

#     it "should set description to Intel64 Family 6 Model 70 Stepping 1" do
#       expect(@plugin[:cpu][cpu_no.to_s][:description])
#         .to eq("Intel64 Family 6 Model 70 Stepping 1")
#     end

#     it "should set model to 17921" do
#       expect(@plugin[:cpu][cpu_no.to_s][:model]).to eq("17921")
#     end

#     it "should set family to 2" do
#       expect(@plugin[:cpu][cpu_no.to_s][:family]).to eq("2")
#     end

#     it "should set stepping to 9" do
#       expect(@plugin[:cpu][cpu_no.to_s][:stepping]).to eq(9)
#     end

#     it "should set cache_size to 64 KB" do
#       expect(@plugin[:cpu][cpu_no.to_s][:cache_size]).to eq("64 KB")
#     end
#   end
# end



# describe Ohai::System, "Windows cpu plugin" do
#   before(:each) do
#     @plugin = get_plugin("cpu")
#     allow(@plugin).to receive(:collect_os).and_return(:windows)

#     @double_wmi_instance = instance_double(WmiLite::Wmi)

#     @processors = [{ "description" => "Intel64 Family 6 Model 70 Stepping 1",
#                      "name" => "Intel(R) Core(TM) i7-4500U CPU @ 1.80GHz",
#                      "deviceid" => "CPU0",
#                      "family" => 2,
#                      "manufacturer" => "GenuineIntel",
#                      "maxclockspeed" => 2793,
#                      "numberofcores" => 1,
#                      "numberoflogicalprocessors" => 2,
#                      "revision" => 17_921,
#                      "stepping" => 9,
#                      "l2cachesize" => 64 },

#                    { "description" => "Intel64 Family 6 Model 70 Stepping 1",
#                      "name" => "Intel(R) Core(TM) i7-4500U CPU @ 1.80GHz",
#                      "deviceid" => "CPU1",
#                      "family" => 2,
#                      "manufacturer" => "GenuineIntel",
#                      "maxclockspeed" => 2793,
#                      "numberofcores" => 1,
#                      "numberoflogicalprocessors" => 2,
#                      "revision" => 17_921,
#                      "stepping" => 9,
#                      "l2cachesize" => 64 }]

#     allow(WmiLite::Wmi).to receive(:new).and_return(@double_wmi_instance)

#     allow(@double_wmi_instance).to receive(:instances_of)
#       .with("Win32_Processor")
#       .and_return(@processors)

#     @plugin.run
#   end

#   it "should set total cpu to 2" do
#     expect(@plugin[:cpu][:total]).to eq(4)
#   end

#   it "should set real cpu to 2" do
#     expect(@plugin[:cpu][:real]).to eq(2)
#   end

#   it "should set 2 distinct cpus numbered 0 and 1" do
#     expect(@plugin[:cpu]).to have_key("0")
#     expect(@plugin[:cpu]).to have_key("1")
#   end

#   it_behaves_like "a cpu", 0
#   it_behaves_like "a cpu", 1
# end
