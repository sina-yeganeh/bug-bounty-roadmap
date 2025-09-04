#! /usr/bin/bash

# If you run script directly, not from 
# python script
if [ "$EUID" -ne 0 ]; then
  echo "Run as root."
  exit 1
fi

# Let loopbacks go through
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Premission to existing connections
iptables -A INPUT -m conntrack -ctstate ESTABLISHED, RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack -ctstate ESTABLISHED, RELATED -j ACCEPT

# Drop modify or malfunction packets - SYN flood prevention
iptables -A INPUT -m conntrack -ctstate INVALID -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP # Null packet

# SSH premision - only local computer can connect via SSH
localip=$(hostname -I | awk '{print $1}')
iptables -A INPUT -p tcp --dport 22 -s $localip/24 -j ACCEPT

# Syn-flood
iptables -A INPUT -p tcp --dport 22 -m limit --limit 3/s -j ACCEPT

# Web access - Prevent DDoS attack
# HTTP:
iptables -A INPUT -p tcp --dport 80 -m limit --limit 10/second --limit-burst 20 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j DROP

# HTTPs:
iptables -A INPUT -p tcp --dport 443 -m limit --limit 10/second --limit-burst 20 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j DROP

# Log invalid packets
iptables -A INPUT -m conntrack --ctstate INVALID -m limit --limit 5/min -j LOG --log-prefix "INVALID-PKT: " --log-level 4
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

# Log dropped new connections (after rate-limiting)
iptables -A INPUT -m conntrack --ctstate NEW -m limit --limit 5/min -j LOG --log-prefix "NEW-DROP: " --log-level 4
iptables -A INPUT -m conntrack --ctstate NEW -j DROP