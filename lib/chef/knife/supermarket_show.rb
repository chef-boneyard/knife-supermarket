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
    class SupermarketShow < Knife::CookbookSiteShow
      # Handle the subclassing (knife doesn't do this :()
      dependency_loaders.concat(superclass.dependency_loaders)
      options.merge!(superclass.options)

      banner "knife supermarket show COOKBOOK [VERSION] (options)"
      category "supermarket"

      option :supermarket_site,
        :short => '-m SUPERMARKET_SITE',
        :long => '--supermarket-site SUPERMARKET_SITE',
        :description => 'Supermarket Site',
        :default => 'https://supermarket.chef.io',
        :proc => Proc.new { |supermarket| Chef::Config[:knife][:supermarket_site] = supermarket }

      def get_cookbook_data
        case @name_args.length
        when 1
          noauth_rest.get("#{config[:supermarket_site]}/api/v1/cookbooks/#{@name_args[0]}")
        when 2
          noauth_rest.get("#{config[:supermarket_site]}/api/v1/cookbooks/#{@name_args[0]}/versions/#{name_args[1].gsub('.', '_')}")
        end
      end

      def get_cookbook_list(items=10, start=0, cookbook_collection={})
        cookbooks_url = "#{config[:supermarket_site]}/api/v1/cookbooks?items=#{items}&start=#{start}"
        cr = noauth_rest.get(cookbooks_url)
        cr["items"].each do |cookbook|
          cookbook_collection[cookbook["cookbook_name"]] = cookbook
        end
        new_start = start + cr["items"].length
        if new_start < cr["total"]
          get_cookbook_list(items, new_start, cookbook_collection)
        else
          cookbook_collection
        end
      end
    end
  end
end
