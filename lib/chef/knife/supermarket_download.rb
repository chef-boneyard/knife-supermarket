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
    class SupermarketDownload < Knife::CookbookSiteDownload

      banner "knife supermarket download COOKBOOK [VERSION] (options)"
      category "supermarket"

      option :supermarket_site,
        :short => '-m SUPERMARKET_SITE',
        :long => '--supermarket-site SUPERMARKET_SITE',
        :description => 'Supermarket Site',
        :default => 'supermarket.getchef.com',
        :proc => Proc.new { |supermarket| Chef::Config[:knife][:supermarket_site] = supermarket }

      def cookbooks_api_url
        "http://#{config[:supermarket_site]}/api/v1/cookbooks"
      end
    end
  end
end
