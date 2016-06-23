# knife-supermarket

This Plugin is DEPRECATED: this feature has been moved into core Chef in
versions greater than 12.11.18 and no longer requires a separate gem
installation.

This Knife Plugin is an easy way to switch between various supermarkets, the
biggest of them being the Chef Community Site, located at
[https://supermarket.chef.io](https://supermarket.chef.io). The `knife
supermarket` commands mimic the `knife cookbook site` commands and work the
same way.

## Installation

If you are running [Chef-DK](https://downloads.chef.io/chef-dk/) you can
install it by running:

    $ chef gem install knife-supermarket

Otherwise, this plugin is distributed as a Ruby Gem. To install it, run:

    $ gem install knife-supermarket

Depending on your system's configuration, you may need to run this command with root privileges.

## Configuration

Out of the box, knife-supermarket is configured to point at [https://supermarket.chef.io](https://supermarket.chef.io), but it can be
configured to point at the unofficial supermarket. This can be done two ways:

### On The Command Line

When using the `knife supermarket` commands you can specify a `--supermarket-site` or `-m` flag and specify the uri of the new supermarket. So, for example, if your supermarket was hosted at `https://franchise.somecompany.com` you could run `knife supermarket install --supermarket-site https://franchise.somecompany.com mysql`.

### `knife.rb` Configuration

It may be preferable to have this setting default to another host. For that, we can set the `knife[:supermarket_site]` setting in our `knife.rb`. So if we
wanted to default to a supermarket hosted at
`https://franchise.somecompany.com` it would be:

    knife[:supermarket_site] = 'https://franchise.somecompany.com'

Now when you run `knife supermarket install mysql` it will install the mysql cookbook from `https://franchise.somecompany.com`.

## Subcommands
The subcommands work the same way they for [knife cookbook site](https://docs.chef.io/chef/knife.html#cookbook-site). Please see
<https://docs.chef.io/chef/knife.html#cookbook-site> for more information on the subcommands.
