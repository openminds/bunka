Santoku
=======

Parallel ssh commands over chef servers with rspec-like output. Santoku uses the exit codes of a command to determine whether it qualifies as a success or failure.

![example](http://i.imgur.com/7kmEHjR.png)

Installation
============

## Requirements

 * Ruby 1.9.3+
 * [Knife configuration file](http://docs.opscode.com/config_rb_knife.html)

Install the gem:

    gem install santoku

Usage
=====

`santoku test COMMAND [QUERY]` or `santoku -t COMMAND [QUERY]`

## Test command

Test if a given command returns 0 on all nodes:

    santoku -t 'test -d /foo/bar/'

Test if a given command **does not** return 0 on nodes:

    santoku -t 'php -i | grep -i memcached' --invert

Test if a given command returns 0 on all nodes, also print out the STDOUT of successfull commands:

    santoku -t 'cat /etc/apache2/conf.d/ssl' --print-success

Test if a given command returns 0, scoped on certain nodes (with [knife search syntax](http://docs.opscode.com/knife_search.html)):

    santoku -t 'test -f /etc/apache2/conf.d/ssl' 'recipe:apache AND listen_ports:443'

### Note

Santoku is not meant to modify server configurations, only to test how a server replies on a given (non-destructive) command. Use with caution.

To-do
=====

 * Make the output truly RSpec compatible, so we can use RSpec formatters
 * Stop forcing root user, system user (with sudo) should also work
 * santoku should not be limited to Chef (main reason this isn't a knife plugin)

Contributing
============

Bug reports, feature requests and test implementations are more than welcome. Please use [our Github account](https://github.com/openminds/santoku) for this.
