# telehash-objc

Objective-C implementation of the full [Telehash](https://github.com/telehash) V3 protocol.

## Current Progress

I am currently working on implementing from the ground up, with platform completeness in mind. Current items in progress are:

* Network interface awareness (state changes, ip changes, etc)
* Serial port support
* Multipeer Connectivity support (soon)

Once the core transport technologies are in place and proven solid, I will proceed with the [E3X](https://github.com/telehash/telehash.org/tree/master/v3/e3x) implementation.

## Setup

I am using git submodules for all the external libraries, so once you have cloned telehash-objc, please run the following:

```
cd telehash-objc
git submodule init
git submodule update
cd externals/libsodium
sh autogen.sh
./dist-build/osx.sh
````

Once those things have been done, you should be able to open the Xcode project and build.


## Thanks To
Many thanks to TWG for their awesome free icon pack (http://blog.twg.ca/2009/09/free-iphone-toolbar-icons/).