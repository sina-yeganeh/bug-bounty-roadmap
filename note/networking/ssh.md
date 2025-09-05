# SSH
The road map my mentor tells to learn:
1. Local Port Forwarding
2. Remote Port Forwarding
3. SSH Tunneling
4. SOCKS Proxy via SSH
5. Password Authentication 
6. File Transfer using `scp`
7. SSH Agent Forwarding

## Local Port Forwarding
Let you take a service running on a remote server and make it accessible on your local machine. Example: 
- A **database** running on `db.company.local:3306` (only accessible inside the company network).
- You’re at home (outside the company network).
- But you have SSH access to `gateway.company.com`.
Command:
``` bash
ssh -L 3306:db.company.local:3306 user@gateway.company.com
```

### Key Points
- It's great for secure access.
- Traffic encrypted by SSH.
- From my machine -> remote service.

## Remote Port Forwarding
Let you expose a local service to the remote server, so other on the remote server's network can access your service. Example:
- You’re running a **web app on your laptop** at `localhost:5000`.
- Your boss (or client) wants to test it, but they can only reach a jump server `jump.company.com`.
- With remote port forwarding, you can make `jump.company.com:8080` point to your local web app.
Command:
```bash
ssh -R 8080:localhost:5000 user@jump.company.com
```
Now:
- Your boss opens `http://jump.company.com:8080`
- The request gets tunneled back to your laptop → your app at `localhost:5000`.

### Key Points
- Remote = from remote server -> my local service
- Used when you want to share your local service with other but can not expose your laptop directly.
- Great for testing, demos or bypassing NAT/firewall.

## SSH Tunneling
An **SSH tunnel** is just an **encrypted pathway** created by SSH to carry other network traffic.  
Think of it like a **secure VPN "mini-tunnel"** for one or more connections.
Local & remote port forwarding are **special cases of SSH tunneling**:
- Local forwarding: _local → remote_
- Remote forwarding: _remote → local_
But SSH tunneling can also be **dynamic** (like SOCKS proxy, which we’ll hit in Part 4).

When you run:
```bash
ssh -L 8080:internal.server:80 user@gateway
```
SSH:
1. Opens a secure channel between your laptop ↔ gateway.
2. Forwards traffic from `localhost:8080` through that channel.
3. Delivers it to `internal.server:80` on the other side.

## SOCKS Proxy
A **SOCKS proxy** lets your applications (like a browser) send traffic through a “middleman” (the proxy).  
With SSH, you can create a SOCKS proxy that routes traffic **through your SSH server**, making it look like all your connections come from that server.
Command:
```bash
ssh -D 1080 user@sshserver.com
```
- `-D 1080`: create a socks proxy on localhost:1080.
- Now any app that support SOCKS5 can use `localhost:1080` as a proxy.

## Recap so far:
- **Local Forwarding**: bring remote -> local
- **Remote Forwarding**: share local -> remote
- **SSH Tunneling**: umbrella concept
- **SOCKS Proxy**: turn SSH into a proxy server for apps

## Passwordless Authentication 
Use public and private key. Public key stored in the SSH server. How it works?
- Generate key pair with `ssh-keyget`
```bash
ssh-keygen -t ed25519 -C "you@example.com"
```
	- `-t`: Key type
	- `-C`: Comment
- Copy public key to the server with:
```bash
ssh-copy-id user@server
```
- And then authentication: when you ssh -> server sends you a challenge -> client sign it with your private key -> server verify it's you by your public key -> you are in!

## SCP vs SFTP vs Rsync
### 1. SCP (Secure Copy)
- Old-school, simple: just copy files between machines over SSH.
- Syntax is like `cp` (easy to remember).
- Fast for one-off transfers.
- But: no resume, limited features.
- Works on: **Linux, Mac, Windows (with OpenSSH/Putty/WinSCP)**.
### 2. SFTP (SSH File Transfer Protocol)
- Runs on top of SSH, but works like an FTP client.
- Interactive: you can list files, cd into directories, transfer multiple files.
- Resumable downloads/uploads.
- Good for manual management of remote files.
- Think: **scp = one-shot copy** vs **sftp = full file manager over SSH**.
### 3. Rsync
- Advanced syncing tool (can use SSH under the hood).
- Only copies _differences_ → much faster for repeated transfers.
- Supports compression (`-z`) and resume.
- Perfect for backups, large projects, or keeping two folders in sync.
- More powerful but more complex than scp.

A quick summary: 
- SCP: quick copy (simple).
- SFTP: interactive file management.
- Rsync: efficient sync, backups, large projects.

## SCP
- Secure copy, it's like `cp` but across machines.
- Syntax:
```bash
scp [options] source destination
```
The switches are exactly like `cp` to.

## SSH Agent Forwarding
Every time you want to log-in you should enter your pass phrase or login with pub/pri key. SSH-agent solve this problem. How it works?
1. This will set environment variables.
```bash
eval $(ssh-agent)
```
2. Add your key:
```bash
ssh-add ~/.ssh/id_ed25519
```
3. Now try SSH:
```bash
ssh user@server
```
4. List loaded keys:
```bash
ssh-add -l
```

Now let's talk about SSH agent forwarding with an example:
- You’re on your laptop (with private key `id_ed25519`).
- You need to SSH into **Server A** first (a bastion/jump host).
- From there, you need to SSH into **Server B** (internal server).
- Server B only trusts your public key, but you don’t want to copy your private key to Server A.
So you can do:
```bash
ssh -A user@serverA
```
and in inside `serverA`:
```bash
ssh user@serverB
```
And done!

### Key Points
- `-A`: enable **Agent** forwarding.
- Your private key never leaves your local machine.
- Useful for:
	- Jump host / bastion servers
	- Multi-ho connections
	- Deployments / automation

# SSH Cheat Sheet for Internship