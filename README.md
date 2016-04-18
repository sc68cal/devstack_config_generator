## DevStack Configuration Generator

This repo contains scripts to create `localrc` files for [DevStack](http://devstack.org), which is
[used to build out a development environment inside of ~~Comcast~~
~~Mirantis~~ my home lab.](http://coreitpro.com/2015/11/11/devstack-home-lab-pt1.html)

## Usage

* Use `rake` to invoke the tasks in the `Rakefile` 

## Access

### SSH

All the nodes should have the same username and password - ideally an
SSH key is generated and installed on the nodes so that no password is
required.

The `stack` user can be used to ssh into compute nodes and do a

	~/devstack/unstack.sh

and

	~/devstack/stack.sh

## Troubleshooting Nova, KVM, and libvirt

If you see the following error in your Devstack logs for n-cpu and you are
running Ubuntu 12.04 LTS:

	2014-05-05 16:06:17.008 TRACE nova.openstack.common.threadgroup     if ret == -1: raise libvirtError ('virConnectGetVersion() failed', conn=self)
	2014-05-05 16:06:17.008 TRACE nova.openstack.common.threadgroup libvirtError: internal error: Cannot find suitable emulator for x86_64

Libvirt has pretty cruddy error reporting, the error message is
misleading, since a -1 error value could be due to many different
circumstances.

When you run the following command - you'll see the following error.

	stack@oscomp-cc38-b01:~$ qemu -device
	qemu: symbol lookup error: qemu: undefined symbol: rbd_aio_discard

You need to do the following:

	$ sudo apt-get install librbd1

[It is related to this bug report: Bug#680307: qemu-kvm: wrong dependency on librdb1 (kvm: symbol lookup error: kvm: undefined symbol: rbd_aio_discard) ](http://us.generation-nt.com/answer/bug-680307-qemu-kvm-wrong-dependency-librdb1-kvm-symbol-lookup-error-kvm-undefined-symbol-rbd-aio-discard-help-208068441.html).

Once you install librbd1, Nova will start up correctly.
