#! /usr/bin/bash

# Delete all default and user configs
iptables -F
iptables -X

# Default policy 
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DRO