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

describe_ohai_plugin :RootGroup do
  let(:plugin_file) { 'root_group' }

  it 'provides attribute: root_group' do
    expect(plugin).to provide_attribute('root_group')
  end

  context 'windows' do
    let(:platform) { 'windows' }

    before :each do
      allow(plugin).to receive(:windows_root_group_name).and_return('Administrators')
    end

    it 'root_group' do
      expect(plugin_attribute('root_group')).to eq('Administrators')
    end
  end

  context 'default' do
    let(:users) do
      <<~USERS
        nobody:*:-2:-2:Unprivileged User:/var/empty:/usr/bin/false
        root:*:0:0:System Administrator:/var/root:/bin/sh
        daemon:*:1:1:System Services:/var/root:/usr/bin/false
      USERS
    end

    let(:groups) do
      <<~GROUPS
        nobody:*:-2:
        nogroup:*:-1:
        root:*:0:root
        daemon:*:1:root
      GROUPS
    end

    before :each do
      allow(plugin).to receive(:users).and_return(users)
      allow(plugin).to receive(:groups).and_return(groups)
    end

    it 'root_group' do
      expect(plugin_attribute('root_group')).to eq('root')
    end
  end
end