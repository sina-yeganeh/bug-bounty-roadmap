# Bug Bounty Roadmap
This repository is just a personal to-do list for becoming a bug hunter. I published it in case anyone is interested in my journey. I should mention that I studied networking and have 3 to 4 years of non-professional programming experience. So That's why I did not add some fundemental stuff to learn.

## Tools
### Burpsuit
- [ ] Proxy
- [ ] Intruder
- [ ] Repeater
- [ ] Decoder
- [ ] Comparer

### Recon
- [ ] `amass` - subdomain enum
- [ ] `subfinder`
- [ ] `httpx`
- [x] `nmap`
- [ ] `dnsx`
- [ ] `waybackurl` - find old URL
- [ ] `gf` - filter suspicious URL

### Fuzzing and Exploitation
This is not a complete list, I will add other tools later.
- [x] `fuff`
- [ ] `wfuzz`
- [x] `sqlmap`
- [ ] `XSStirke`
- [ ] `dirsearch` - find hidden path
- [ ] `gobuster`
- [ ] `arjun`

## ‌Bug Classes
### Server-side
- [ ] SQLi
- [ ] Authentication Issues
	- [ ] Session hijacking
		- [ ] Understanding cookie and JWT
		- [ ] Burp: Repeater + Intercept
	- [ ] Brut force login
		- [ ] `fuff` / `hydra` / Burp Intruder
		- [ ] Detect rate limits and bypass them
		- [ ] Account lockout policy
- [ ] Access Control Issues
	- [ ] IDOR (Insecure Direct Object Reference)
	- [ ] Vertical and horizontal privilege Escalation 
		- [ ] user -> admin
		- [ ] user A -> user B
		- [ ] Roles and endpoints
- [ ] File Vulnerabilities
	- [ ] Content-type attack
	- [ ] Extension double bypass
	- [ ] Null-byte attack
	- [ ] Path traversal
- [ ] SSRF (Server Side Request Forgery)
	- [ ] Inside exploitation
	- [ ] Internal services scan
	- [ ] Test with different method: `GET`, `POST`, ...
- [ ] XXE (XML External Entity) - Command Injection
	- [ ] XEE
		- [ ] DTD & ENTITY
		- [ ] Local file inclusion (`file:///etc/passwd`)
		- [ ] DNS exfiltration or blind XEE
	- [ ] Command injection
		- [ ] Inject command to endpoints which use shell
		- [ ] Use `;`, `&&`, `|`, etc ...
		- [ ] Blind command injection (`sleep 10`)

### Client-side and Logical
- [ ] XSS
	- [ ] Stored
	- [ ] Reflected
	- [ ] DOM-based
- [ ] CSRF (Cross-Site Request Forgery)
	- [ ] Form without token
	- [ ] Test `POST` vs `GET`
	- [ ] Test with `<img src="...">` and hidden form
- [ ] Open Redirect
	- [ ] Phishing 
	- [ ] Bypass protection (redirect to internal endpoint)
- [ ] Clickjacking
	- [ ] X-Frame-Options
	- [ ] Create fake page with `<iframe>` and fake button
	- [ ] `Burp Clickbandit`
- [ ] WebSocket Vulnerabilities
	- [ ] Send message without auth
	- [ ] See others message
	- [ ] Inject code in payload
	- [ ] Test XSS in web socket messages
- [ ] Business Logic Bugs
- [ ] Client-side Validation Bypass

### Others
- [ ] Web LLM Attacks

## To-Do Table
Every Friday, I add a new task for the following week, along with a link to the course or content if it is available.

| Week No. | Tasks | Practice | Status |
| -------- | -------- | -------- | -------- |
| 1 | [Access control issues](https://portswigger.net/web-security/learning-paths/server-side-vulnerabilities-apprentice/access-control-apprentice/access-control/what-is-access-control), [authentication issues](https://portswigger.net/web-security/learning-paths/authentication-vulnerabilities/what-is-authentication/authentication/what-is-authentication) | PortSwigger | :x: |

 
