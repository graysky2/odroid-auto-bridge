# odroid-auto-bridge
Simple method to create a bridge for the [ODROID](http://www.hardkernel.com/main/main.php)-C1+/C2/XU4.

## Rationale
Is is known that both the ODROID-C1+ and ODROID-C2 (perhaps others) have a limitation with network bridges, at least as they apply to established network tools such as [netctl](http://projects.archlinux.org/netctl.git/) and [systemd-networkd](https://www.github.com/systemd/systemd). For some reason, neither tool is able to create and bring up a usable network bridge needed for linux containers among other things.

## Solution
A simple solution to this problem is to use [iproute2](http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2) and [bridge-utils](http://www.linuxfoundation.org/collaborate/workgroups/networking/bridge) to create the bridge _before_ either of the network managers is called. Once created, both netctl and systemd-networkd work to bring up the bridge.

This repo supplies a simple script to create the bridge and a systemd unit to call it.  Enjoy!

## Installation
* Users of Arch ARM can download [odroid-auto-bridge](https://aur.archlinux.org/packages/odroid-auto-bridge) from the AUR.
* Users of other distros can simply install manually, see: [INSTALL](https://github.com/graysky2/odroid-auto-bridge/blob/master/INSTALL) for dependencies and instructions.

## Upstream bug reports/forum posts referencing this limitation
* https://github.com/systemd/systemd/issues/3648
* https://github.com/systemd/systemd/issues/4945
* http://forum.odroid.com/viewtopic.php?f=141&t=25129

## Examples
Note - Both examples below use DHCP; obviously static and more advanced setups can be used. See the respective man pages for systemd.network and netctl man page for more options.

### Using systemd-networkd

1. Enable the odroid-auto-bridge service: `systemctl enable odroid-auto-bridge`
2. Create the following unit in `/etc/systemd/network/` and insure that you have enabled the [required services](https://wiki.archlinux.org/index.php/Systemd-networkd#Required_services_and_setup), then reboot:
```
# /etc/systemd/network/bridge.network
[Match]
Name=br0

[Network]
DHCP=yes
```
### Using netctl
1. Enable the odroid-auto-bridge service: `systemctl enable odroid-auto-bridge`
2. Create the following profile in `/etc/netctl/` and insure that you have [enabled](https://wiki.archlinux.org/index.php/Netctl#Basic_method) it, then reboot:
```
# /etc/netctl/bridge
Description="Example Bridge connection"
Interface=br0
Connection=bridge
BindsToInterfaces=(eth0)
IP=dhcp
```
