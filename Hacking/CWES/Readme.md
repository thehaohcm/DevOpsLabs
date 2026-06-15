### Resources:

https://www.udemy.com/course/learn-bug-bounty-hunting-web-security-testing-from-scratch (1 month)

https://www.reddit.com/r/hackthebox/comments/1u2mrwh/cwes_preparation/

PortSwigger Web Security Academy (2 months)

OWASP Juice Shop (2 months)

CWES (1 month)

Report tools (for CWES exam): https://github.com/Syslifters/HackTheBox-Reporting

### Labs

https://orange-cyberdefense.github.io/GOAD/labs/MINILAB/

https://hackthebox.com

htpps://tryhackme.com

### Cheat sheets:

https://github.com/Touexe/CBBH-CWES

https://github.com/Burdy98/Pentest-Methodology/blob/main/CWES-Methodology.md

### Tools/Others:

http://portswigger.net/: collection of all vulnerable websites, we can choose and practice on these websites safely & legally

## Reconnaissance & Enumeration tools

# Infrastructure & Network

nmap

https://github.com/bee-san/RustScan

# Web Surface

https://github.com/OJ/gobuster

https://github.com/epi052/feroxbuster

https://github.com/maurosoria/dirsearch

# list of common vulnerability

https://github.com/danielmiessler/SecLists/blob/master/Discovery/Web-Content/common.txt

# Vulnerability Scanning

https://github.com/projectdiscovery/nuclei

https://github.com/aquasecurity/trivy

https://github.com/aquasecurity/kube-hunter

# Exploitation & Deep Testing

https://portswigger.net/burp

https://github.com/zaproxy/zaproxy

https://github.com/ffuf/ffuf

https://github.com/xmendez/wfuzz

# Common flow:

nmap/rustscan -> find out port 80/433 -> use feroxbuster -> find out path /api/v1/user -> use Burp suite -> analyze api request -> use ffuf -> brute-force ID parameter -> find out IDOR (Insecure Direct Object Reference) or use Nuclei -> scan API CVE

## Attack Techniques:

# Attack Active Directory & Internal network

NetExec / CrackMapExec: password spraying, list share SMB, check admin privilenge, execute remotely cmd

Impacket: get sensitive data

BloodHound & SharpHound: collewct AD data and draw map, find out a chain of complex atatck

Responder: Poisoning LLMNR/NBT-NS, collect NTLMv2

Rubeus & Minikatz: 

# Privillege Escalation

WinPEAS / LinPEAS

# Pivoting & Tunneling

Ligolo-ng

Chisel


### SQL Injections:

'

"

--

`#

UNION SELECT NULL--

# tools:

https://github.com/sqlmapproject/sqlmap

### XSS
```
<script>alert(1)</script>

<img src=x onerror=alert(1)>

# tools:

https://github.com/webhooksite/webhook.site

XSS Hunder

```
### SSRF

payload http://127.0.0.1 -> server returns its public ip in cloud

### JWT

alg:none

Weak secret

Session Cookie

Trust Client Claims

### File Upload

shell.php.jpg

.phtml

.phar

### Access Control

IDOR:

ID=1 -> ID=2 -> ID=3

Vertical Privilege Escalation

User -> Admin

Horizontal Privilege Escalation

User1 -> User2

# Authentication

Brute Force

Password Spraying

MFA Bypass

Session Fixation

### Business Logic

Coupon discount $50 -> discount more $50 -> loop 

# Tools

Proxy

Repeater

Decoder (JWT, Base64)

Intruder

Logger

# Mock exam

Build on your self

### DVWA (Damn Vulnerable Web Application): create a bugging web application for pentest
```
docker run --rm -it \
-p 4280:80 \
vulnerables/web-dvwa
```

### bWAPP (Buggy Web Application): create a bug web application, more than DVWA
```
docker run -d \
-p 8080:80 \
raesene/bwapp
```

### Juice shop (OWASP Juice Shop, a bugging e-commerce website, same as real life)
```
docker run -d \
-p 3000:3000 \
bkimminich/juice-shop
```

### PortSwigger: Hacking labs

### target: Gaining system control for 2 hours

### Others

SysReport

Obsidian / Notion
