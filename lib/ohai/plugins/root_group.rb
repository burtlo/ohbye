#
# Author:: Joseph Anthony Pasquale Holsten (<joseph@josephholsten.com>)
# Copyright:: Copyright (c) 2013 Joseph Anthony Pasquale Holsten
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

Ohai.plugin(:RootGroup) do
  provides "root_group"

  # Per http://support.microsoft.com/kb/243330 SID: S-1-5-32-544 is the
  # internal name for the Administrators group, which lets us work
  # properly in environments with a renamed or localized name for the
  # Administrators group.
  # Use LocalAccount=True because otherwise WMI will attempt to include
  # (unneeded) Active Directory groups by querying AD, which is a performance
  # and reliability issue since AD might not be reachable.
  def windows_root_group_name
    shell_out("Get-LocalGroup -SID 'S-1-5-32-544' | Select-Object -ExpandProperty Name").stdout.strip
  end

  collect_data(:windows) do
    root_group windows_root_group_name
  end

  def users
    file_read('/etc/passwd')
  end

  def groups
    file_read('/etc/group')
  end

  collect_data(:default) do
    all_users = users.lines.map do |line|
      name, has_password, uid, gid, gecos, dir, shell = line.strip.split(':')
      Mash.new(name: name, dir: dir, gid: gid, uid: uid, shell: shell, gecos: gecos)
    end

    root_user = all_users.find { |u| u[:name] == 'root' }
    
    all_groups = groups.lines.map do |line|
      name, has_password, gid, members = line.strip.split(':')
      Mash.new(name: name, gid: gid, members: members.to_s.split(","))
    end
    
    found_root_group = all_groups.find { |group| group[:gid] == root_user[:gid] }

    if found_root_group
      root_group found_root_group[:name]
    end
  end
end
