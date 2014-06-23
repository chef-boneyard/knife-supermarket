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

      banner "knife supermarket share COOKBOOK CATEGORY (options)"
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
        :default => 'https://supermarket.getchef.com',
        :proc => Proc.new { |supermarket| Chef::Config[:knife][:supermarket_site] = supermarket }

      def do_upload(cookbook_filename, cookbook_category, user_id, user_secret_filename)
         uri = "#{config[:supermarket_site]}/api/v1/cookbooks"

         category_string = { 'category'=>cookbook_category }.to_json

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
