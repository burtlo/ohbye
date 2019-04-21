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

describe_ohai_plugin :Powershell do
  let(:plugin_file) { 'powershell' }

  it 'provides attribute: languages/powershell' do
    expect(plugin).to provide_attribute('languages/powershell')
  end

  it 'depends on: languages' do
    expect(plugin).to depend_on_attribute('languages')
  end

  context 'windows' do
    let(:platform) { 'windows' }

    let(:powershell_version_table) do
      <<~TABLE
      Name                           Value
      ----                           -----
      PSVersion                      4.0
      WSManStackVersion              3.0
      SerializationVersion           1.1.0.1
      CLRVersion                     4.0.30319.34014
      BuildVersion                   6.3.9600.16394
      PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0}
      PSRemotingProtocolVersion      2.2
      TABLE
    end

    before :each do
      allow(plugin).to receive(:powershell_version_table).and_return(powershell_version_table)
      # TODO: this should be automatic with the depends_on
      allow(plugin).to receive(:languages).and_return(Mash.new)
    end

    it 'version' do
      expect(plugin_attribute('languages/powershell/version')).to eq('4.0')
    end

    it 'ws_man_stack_version' do
      expect(plugin_attribute('languages/powershell/ws_man_stack_version')).to eq('3.0')
    end

    it 'serialization_version' do
      expect(plugin_attribute('languages/powershell/serialization_version')).to eq('1.1.0.1')
    end

    it 'clr_version' do
      expect(plugin_attribute('languages/powershell/clr_version')).to eq('4.0.30319.34014')
    end

    it 'build_version' do
      expect(plugin_attribute('languages/powershell/build_version')).to eq('6.3.9600.16394')
    end

    it 'compatible_versions' do
      expect(plugin_attribute('languages/powershell/compatible_versions')).to eq(%w[ 1.0 2.0 3.0 4.0 ])
    end

    it 'remoting_protocol_version' do
      expect(plugin_attribute('languages/powershell/remoting_protocol_version')).to eq('2.2')
    end
  end
end