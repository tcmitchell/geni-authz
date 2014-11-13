#
# Cookbook Name:: geni-authz
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

# See http://docs.getchef.com/resource_remote_file.html

# Download branch tkt660_gcfauth of gcf.
# TODO: when this is released, update to the appropriate download of gcf
gcf_dir = "gcf-8c834a5dcb"
src_url = "http://www.gpolab.bbn.com/experiment-support/gposw/aa/#{gcf_dir}.tar.gz"
src_checksum = "7a6ad1fa87a1817bf4af11b6465548965e03e4c4cf276bd2c610c57e80926fd8"
src_filepath = "#{Chef::Config[:file_cache_path]}/#{gcf_dir}.tar.gz"
extract_path = "/opt"
dest_path = "#{extract_path}/#{gcf_dir}"
config_dir = "/etc/geni-authz"

remote_file src_filepath do
  source "#{src_url}"
  checksum "#{src_checksum}"
end


bash 'extract_module' do
  code <<-EOH
    mkdir -p #{extract_path}
    tar xzf #{src_filepath} -C #{extract_path}
    EOH
  not_if { ::File.exists?(dest_path) }
end

# Create the config dir
bash 'config_dir' do
  code <<-EOH
    mkdir -p #{config_dir}
    EOH
  not_if { ::File.directory?(config_dir) }
end

# Install the policy map file from a template
template "/etc/geni-authz/policy-map.json" do
  source "policy-map.json.erb"
  variables({
              :gcf_dir => "#{dest_path}"
            })
end
