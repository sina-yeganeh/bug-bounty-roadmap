# Introduction to `iptables`
Section of `iptables`:
- Table: Rules grouped into the tables. Each table has a specific purpose:
	- `filter`: allow/deny packets (ACCEPT/DROP/REJECT), It is the default tables.
	- `nat`: Translate address/port (SNAT, DNAT, MASQUERADE).
	- `mangel`: Modify the packets.
	- `raw`: Make exception/bypass connection tracking.
	- `secuirty`: Used with Linux Security Modules(LSM)
- Chain: Each table contains chains. Chains are like the stage which the packet pass through. Different type of them:
	- `INPUT`: Packet destined to your local machine.
	- `OUTPUT`: Created by your computer.
	- `FORWARD`: The packets passing through your system. (when the system act like a router)
	- `PREROUTING`: Before the routing decision are made.
	- `POSTROUTING`: After the routing decision, right after the packet leaving your computer.
- Rules = condition: Inside chains, there are some rules. A rule basically is a "if -> then" statement:
	- if (condition) -> condition: protocol, port, source IP, etc ...
	- then (`target`) -> ACCEPT, DROP, REJECT, DNAT.
	- If a packet dos not match any rule there is a default policy like `ACCEPT` or `DROP`
- Target = action: The *action* to take once a rule matches. The most common:
	- `ACCEPT`
	- `DROP`: Silently discord it.
	- `REJECT`: Discard and send back an error message to sender.
	- `LOG`: Log the packet, but do not drop it.
	- `DNAT, SNAT, MASQUERAED`: Change the address/port.

## Example
#### Secure server (SSH + Web)
```bash
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: "
```
#### Rate limit
```bash
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set --name SSH
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 4 --name SSH -j DROP
```
