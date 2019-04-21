#
# Copyright:: Copyright (c) 2014-2016 Chef Software, Inc.
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

Ohai.plugin(:Powershell) do
  provides "languages/powershell"
  depends "languages"

  # Sample output:
  #
  # Name                           Value
  # ----                           -----
  # PSVersion                      4.0
  # WSManStackVersion              3.0
  # SerializationVersion           1.1.0.1
  # CLRVersion                     4.0.30319.34014
  # BuildVersion                   6.3.9600.16394
  # PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0}
  # PSRemotingProtocolVersion      2.2
  def powershell_version_table
    shell_out("$PSVersionTable").stdout.strip
  end

  collect_data(:windows) do
    results = powershell_version_table
    next if results.empty?

    info = {}

    results.each_line.inject(info) do |hash, line|
      name, value = line.strip.split(/\s+/, 2)
      hash[name] = value if name && value
      hash
    end

    powershell = Mash.new

    powershell[:version] = info["PSVersion"]
    powershell[:ws_man_stack_version] = info["WSManStackVersion"]
    powershell[:serialization_version] = info["SerializationVersion"]
    powershell[:clr_version] = info["CLRVersion"]
    powershell[:build_version] = info["BuildVersion"]
    powershell[:compatible_versions] = info["PSCompatibleVersions"].scan(/\d\.\d/)
    powershell[:remoting_protocol_version] = info["PSRemotingProtocolVersion"]

    languages[:powershell] = powershell unless powershell.empty?
  end
end
