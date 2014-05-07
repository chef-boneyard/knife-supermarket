# knife-supermarket

This Knife Plugin is an easy way to switch between various supermarkets, the biggest of them being the Chef Community Site, soon to be located at [http://supermarket.getchef.com](http://supermarket.getchef.com). The `knife supermarket` commands mimic the `knife cookbook site` commands and work the same way.

## Installation

If you are running [Chef-DK](http://www.getchef.com/downloads/chef-dk) you can install it by running:

    $ chef gem install knife-openstack

Otherwise, this plugin is distributed as a Ruby Gem. To install it, run:

    $ gem install knife-openstack

Depending on your system's configuration, you may need to run this command with root privileges.

## Configuration

Out of the box, knife-supermarket is configured to point at [http://supermarket.getchef.com](http://supermarket.getchef.com), but it can be configured to point at a supermarket that isn't the official one. To do this you can do this a few ways:

### On The Command Line

When using the `knife supermarket` commands you can specify a `--supermarket-site` or `-m` flag and specify the hostname of the new supermarket. So, for example, if your supermarket was hosted at `franchise.somecompany.com` you could run `knife supermarket install --supermarket-site franchise.somecompany.com mysql`.

### `knife.rb` Configuration

It may be preferable to use have this setting default to another host. For that, we can set the `knife[:supermarket_site]` setting in our `knife.rb`. So if we wanted to default to a supermarket hosted at `franchise.somecompany.com` it would be:

    knife[:supermarket_site] = 'franchise.somecompany.com'

Now when you run `knife supermarket install mysql` it will install the mysql cookbook from `franchise.somecompany.com`.

## Subcommands

The subcommands work the same way they for [knife cookbook site](http://docs.opscode.com/chef/knife.html#cookbook-site). Please see [http://docs.opscode.com/chef/knife.html#cookbook-site](http://docs.opscode.com/chef/knife.html#cookbook-site) for more information on the subcommands.
