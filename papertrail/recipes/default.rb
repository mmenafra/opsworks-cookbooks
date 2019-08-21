#
# Cookbook Name:: papertrail
# Recipe:: default
#
# Copyright 2011, Librato, Inc.
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
##

execute 'download papertrail' do
  command 'wget https://github.com/papertrail/remote_syslog2/releases/download/v0.20/remote_syslog_linux_amd64.tar.gz'
  user 'root'
  action :run
end

execute 'extract contents ' do
  command 'tar xzf ./remote_syslog*.tar.gz'
  user 'root'
  action :run
end

execute 'cd to folder' do
  command 'cd remote_syslog'
  user 'root'
  action :run
end

execute 'copy contents ' do
  command 'sudo cp ./remote_syslog /usr/local/bin'
  user 'root'
  action :run
end

execute 'run papertrail' do
  command 'sudo remote_syslog -p 21986 -d logs4.papertrailapp.com --pid-file=/var/run/remote_syslog.pid /srv/www/utilities/shared/log/utilities.log'
  user 'root'
  action :run
end

# return unless node['papertrail']['logger'] == "rsyslog"

# syslogger = "rsyslog"

# #include_recipe "rsyslog"

# package "rsyslog-gnutls" do
#   action :install

#   # Allow installation of rsyslog-gnutls from source
#   not_if { File.exist?("/usr/lib/rsyslog/lmnsd_gtls.so") }
# end

# remote_file node['papertrail']['cert_file'] do
#   source node['papertrail']['cert_url']
#   mode "0444"
# end

# syslogdir = "/etc/rsyslog.d"

# if node['papertrail']['watch_files'] && !node['papertrail']['watch_files'].empty?
#   watch_file_array = []

#   if node['papertrail']['watch_files'].respond_to?(:keys)

#     require 'digest/sha1'

#     node['papertrail']['watch_files'].each do |filename, tag|
#       watch_file_array << {
#         :filename => filename,
#         :tag => tag
#       }
#     end

#     # Sort to preserve order of the config
#     watch_file_array = watch_file_array.sort { |a, b| a[:filename] <=> b[:filename] }

#   elsif node['papertrail']['watch_files'].is_a?(Array)

#     # Deprecate but retain backwards compatibility
#     Chef::Log.info "DEPRECATION WARNING: Please convert this node's ['papertrail']['watch_files'] attribute from an Array to a Hash"
#     Chef::Log.info "                     to allow use of override_attribtutes for addition of watch_files"

#     watch_file_array = node['papertrail']['watch_files']
#   end

#   template "#{syslogdir}/60-watch-files.conf" do
#     source "watch-files.conf.erb"
#     owner "root"
#     group "root"
#     mode "0644"
#     variables(:watch_files => watch_file_array)
#     notifies :restart, "service[#{syslogger}]"
#   end
# end

# hostname_name = node['papertrail']['hostname_name'].to_s
# hostname_cmd  = node['papertrail']['hostname_cmd'].to_s

# unless hostname_name.empty? && hostname_cmd.empty?
#   node.set['papertrail']['fixhostname'] = true

#   if !hostname_name.empty?
#     name = hostname_name
#   else
#     cmd = Mixlib::ShellOut.new(hostname_cmd)
#     cmd.run_command
#     name = cmd.stdout.chomp
#   end

#   template "#{syslogdir}/61-fixhostnames.conf" do
#     source "fixhostnames.conf.erb"
#     owner "root"
#     group "root"
#     mode "0644"
#     variables(:name => name)
#     notifies :restart, "service[#{syslogger}]"
#   end
# end

# template "#{syslogdir}/65-papertrail.conf" do
#   source "papertrail.conf.erb"
#   owner "root"
#   group "root"
#   mode "0644"
#   variables(:cert_file => node['papertrail']['cert_file'],
#             :host => node['papertrail']['remote_host'],
#             :port => node['papertrail']['remote_port'],
#             :fixhostname => node['papertrail']['fixhostname'])
#   notifies :restart, "service[#{syslogger}]"
# end