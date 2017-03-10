#
# Cookbook:: rs-iis
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#
include_recipe 'iis'
include_recipe 'iis::mod_aspnet45'
include_recipe 'iis::mod_auth_anonymous'
include_recipe 'iis::mod_compress_static'

remote_file ::File.join(Chef::Config['file_cache_path'], 'BlogEngineNet33.zip') do
  source 'https://s3.amazonaws.com/rs-professional-services-publishing/tmp/BlogEngineNet33.zip'
  action :create
end

seven_zip_archive 'seven_zip_source' do
  path      'C:\BlogEngineNet33'
  source    ::File.join(Chef::Config['file_cache_path'], 'BlogEngineNet33.zip')
  overwrite true
  timeout   30
end

# stop and delete the default site
iis_site 'Default Web Site' do
  action [:stop, :delete]
end

iis_site 'BlogEngineNet33' do
  protocol :http
  port 80
  path 'C:\BlogEngineNet33'
  action [:add,:start]
end
