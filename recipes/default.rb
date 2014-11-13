#
# Cookbook Name:: geni-authz
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

# See http://docs.getchef.com/resource_remote_file.html

# Download branch tkt660_gcfauth of gcf.
# TODO: when this is released, update to the appropriate download of gcf
gcf_dir = "/gcf-4094de01de"
src_url = "http://www.gpolab.bbn.com/experiment-support/gposw/aa/#{gcf_dir}.tar.gz"
src_checksum = "40664f1cb2b2cbabeabea980507dcddc5ba1ef1dab5a79c2a6eb540909e7afbf"
src_filepath = "#{Chef::Config[:file_cache_path]}/#{gcf_dir}.tar.gz"
extract_path = "/opt"
dest_path = "#{extract_path}/#{gcf_dir}"

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
