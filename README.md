## DevStack Configuration Generator

This repo contains scripts to create `localrc` files for [DevStack](http://devstack.org), which is
[used to build out a development environment inside of ~~Comcast~~
~~Mirantis~~ my home lab.](http://coreitpro.com/2015/11/11/devstack-home-lab-pt1.html)

## Usage

* Use `rake` to invoke the tasks in the `Rakefile`. `rake` with no
  arguments will generate the configurations, copy them to each node
  in the cluster defined in `settings.yml` then restack (`unstack.sh`
  && `stack.sh`) the nodes.

## Access

### SSH

All the nodes should have the same username and password - ideally an
SSH key is generated and installed on the nodes so that no password is
required.
