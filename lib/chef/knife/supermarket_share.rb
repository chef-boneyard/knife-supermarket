#
# Author:: Christopher Webber (<cwebber@getchef.com>)
# Copyright:: Copyright (c) 2014 Chef Software, Inc.
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

require 'chef/knife'

class Chef
  class Knife
    class SupermarketShare < Knife::CookbookSiteShare

      banner "knife supermarket share COOKBOOK (options)"
      category "supermarket"

      deps do
        require 'chef/cookbook_loader'
        require 'chef/cookbook_uploader'
        require 'chef/cookbook_site_streaming_uploader'
      end

      option :supermarket_site,
        :short => '-m SUPERMARKET_SITE',
        :long => '--supermarket-site SUPERMARKET_SITE',
        :description => 'Supermarket Site',
        :default => 'https://supermarket.chef.io',
        :proc => Proc.new { |supermarket| Chef::Config[:knife][:supermarket_site] = supermarket }

      option :cookbook_path,
        :short => "-o PATH:PATH",
        :long => "--cookbook-path PATH:PATH",
        :description => "A colon-separated path to look for cookbooks in",
        :proc => lambda { |o| Chef::Config.cookbook_path = o.split(":") }

      # since we subclass cookbook_site and it expects a category, pass a phantom empty category
      # parameter before invoking Chef::Knife::CookbookSiteShare#run ...
      # Tested on 11.16.4 and 12.0.3.
      def run
        @name_args << "" if @name_args.length == 1
        super
      end
      def do_upload(cookbook_filename, cookbook_category, user_id, user_secret_filename)
         uri = "#{config[:supermarket_site]}/api/v1/cookbooks"

         # Categories are optional both in knife cookbook site
         # (which this plugin seeks to replace) and on the
         # Supermarket community site.  Best practice now
         # seems to be to just omit the category entirely.
         #
         # see:
         # https://github.com/chef/supermarket/pull/915
         # https://github.com/chef/chef/pull/2198

         category_string = { 'category'=>'' }.to_json

         http_resp = Chef::CookbookSiteStreamingUploader.post(uri, user_id, user_secret_filename, {
           :tarball => File.open(cookbook_filename),
           :cookbook => category_string
         })

         res = Chef::JSONCompat.from_json(http_resp.body)
         if http_resp.code.to_i != 201
           if res['error_messages']
             if res['error_messages'][0] =~ /Version already exists/
               ui.error "The same version of this cookbook already exists on the Opscode Cookbook Site."
               exit(1)
             else
               ui.error "#{res['error_messages'][0]}"
               exit(1)
             end
           else
             ui.error "Unknown error while sharing cookbook"
             ui.error "Server response: #{http_resp.body}"
             exit(1)
           end
         end
         res
      end
    end
  end
end
