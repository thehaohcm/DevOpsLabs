# HTB CWES (CBBH) Command Cheat Sheet

Đây là bản tóm tắt các công cụ dòng lệnh (CLI) cốt lõi phục vụ cho việc rà quét, tấn công và leo quyền trong kỳ thi HTB Certified Web Exploitation Specialist.

## 1. Reconnaissance & Enumeration (Rà quét & Thu thập thông tin)

### Nmap (Quét cổng và dịch vụ)
```bash
# Quét toàn bộ cổng, dò phiên bản dịch vụ và chạy script mặc định
nmap -p- -sV -sC -Pn <TARGET_IP>
```

### WhatWeb (Nhận diện công nghệ nền tảng)
```bash
# Quét chuyên sâu mức độ 3 để nhận diện Tech Stack
whatweb -a 3 http://<TARGET_IP>
```

### WPScan (Quét lỗ hổng WordPress - Cực kỳ phổ biến trong HTB)
```bash
# Liệt kê người dùng (u), plugin lỗi (vp), theme lỗi (vt)
wpscan --url http://<TARGET_IP> --enumerate u,vp,vt --api-token <YOUR_TOKEN>
```

## 2. Fuzzing & Discovery (Dò tìm tự động)

### FFUF (Fuzzing Thư mục, VHost, Tham số)
```bash
# Dò tìm thư mục/file ẩn
ffuf -w /usr/share/wordlists/dirb/common.txt -u http://<TARGET_IP>/FUZZ -mc 200,301,302

# Dò tìm Virtual Host (VHost) - Lọc bỏ các trang lỗi có size cố định (-fs)
ffuf -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt -u http://<TARGET_DOMAIN> -H "Host: FUZZ.<TARGET_DOMAIN>" -fs 42

# Dò tìm tham số (Parameter) cho GET Request
ffuf -w /usr/share/wordlists/SecLists/Discovery/Web-Content/burp-parameter-names.txt -u http://<TARGET_IP>/api/users?FUZZ=test
```

### Gobuster (Dò VHost thay thế ổn định)
```bash
gobuster vhost -u http://<TARGET_DOMAIN> -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt --append-domain
```

### Feroxbuster (Dò tìm thư mục đệ quy cực nhanh bằng Rust)
```bash
# Dò tìm đệ quy (tự động quét tiếp vào các thư mục tìm thấy) và tìm các file có đuôi cụ thể
feroxbuster -u http://<TARGET_IP> -w /usr/share/wordlists/dirb/common.txt -x php,html,txt,bak
```

### Kiterunner (Dò tìm API Endpoints chuyên sâu)
```bash
kr scan http://<TARGET_IP>/api -w /opt/kiterunner/routes-large.kite
```

### Arjun (Tìm kiếm tham số ẩn trên API/Web)
```bash
# Tự động dò tìm các tham số GET hoặc POST chưa được công bố trên API endpoint
arjun -u http://<TARGET_IP>/api/endpoint -m GET
```

## 3. Web & API Interaction (Tương tác Web/API)

### cURL (Gửi HTTP Request)
```bash
# Gửi POST request dạng JSON kèm Token xác thực, bỏ qua lỗi SSL (-k)
curl -i -s -k -X POST -H "Content-Type: application/json" -H "Authorization: Bearer <TOKEN>" -d '{"username":"admin", "password":"123"}' http://<TARGET_IP>/api/login
```

## 4. Exploitation Tools (Công cụ khai thác chuyên sâu)

### SQLMap (Tấn công SQL Injection)
```bash
# Khai thác cơ bản từ URL
sqlmap -u "http://<TARGET_IP>/product.php?id=1" --batch --dbs

# Khai thác thông qua file request lưu từ Burp Suite (tập trung vào tham số username)
sqlmap -r req.txt -p username --level 3 --risk 2 --dbms=postgresql
```

### Dalfox (Tự động hóa quét XSS)
```bash
dalfox url "http://<TARGET_IP>/search?q=test"
```

### Tplmap (Tấn công Server-Side Template Injection - SSTI)
```bash
# Khai thác SSTI và lấy thẳng OS Shell
tplmap.py -u "http://<TARGET_IP>/page?name=*" --os-shell
```

### Commix (Tấn công OS Command Injection)
```bash
# Tự động hóa quá trình tìm kiếm và chèn mã thực thi lệnh hệ điều hành
commix --url="http://<TARGET_IP>/ping.php?ip=127.0.0.1" --os-cmd="id"
```

### jwt_tool (Tấn công JSON Web Tokens)
```bash
# Chạy toàn bộ kịch bản tấn công cơ bản (Playbook)
python3 jwt_tool.py <TOKEN> -M pb

# Brute-force bẻ khóa Secret Key của JWT
python3 jwt_tool.py <TOKEN> -C -d /usr/share/wordlists/rockyou.txt
```

### Gopherus (Khai thác SSRF qua các dịch vụ nội bộ)
```bash
# Tạo payload gopher:// để khai thác RCE qua Redis nội bộ
gopherus --exploit redis
```

### Hydra (Brute-force Form Đăng nhập Web)
```bash
# Brute-force POST Form dựa trên thông báo lỗi "Incorrect"
hydra -l admin -P /usr/share/wordlists/rockyou.txt <TARGET_IP> http-post-form "/login.php:user=^USER^&pass=^PASS^:F=Incorrect"
```

### Nuclei (Quét lỗ hổng dựa trên Template)
```bash
nuclei -u http://<TARGET_IP> -tags cve,lfi,ssrf
```

## 5. Post-Exploitation & Data Extraction (Hậu khai thác & Trích xuất dữ liệu)

### CeWL (Tạo từ điển tùy chỉnh)
```bash
# Cào từ vựng trên web mục tiêu để tạo wordlist (chiều sâu 2, từ dài tối thiểu 5 ký tự)
cewl -d 2 -m 5 -w custom_wordlist.txt http://<TARGET_IP>
```

### Hashcat (Bẻ khóa mật khẩu)
```bash
# Bẻ khóa hash bằng wordlist (Ví dụ: -m 3200 cho Bcrypt, -m 0 cho MD5)
hashcat -a 0 -m 3200 hash.txt /usr/share/wordlists/rockyou.txt
```

### GitTools (Khôi phục mã nguồn bị rò rỉ)
```bash
# Tải toàn bộ thư mục .git đang mở public
bash gitdumper.sh http://<TARGET_IP>/.git/ dest_folder

# Trích xuất commit thành mã nguồn hoàn chỉnh
bash extractor.sh dest_folder dest_repo
```

### Responder (Bắt NTLM Hash qua SSRF/LFI)
```bash
responder -I tun0 -rdw
```

### Netcat (Lắng nghe kết nối Reverse Shell)
```bash
# Mở cổng lắng nghe shell trả về
nc -lvnp 4444
```

### Check domain contractor
```bash
# whois [domain]
```

### Check domain info
```bash
# dig [domain/IP] [record (A/MX/...)
# dig +short [domain/IP]
```

### Check doamin mapped to IP (reversing)
```bash
# dig +x [IP]
```

### Subdomain bruteforcing
```bash
# dnsenum --enum [domain] -f  /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt
```

# DNS Zone Transfers (AXFR)
## Defination
DNS Zone transfers is a wholesale copy of all DNS records within a zone (domain and its subdomains) from one name server to another for maintaining consistency and redundancy across DNS servers. There are 5 steps:
 1. secondary DNS name servers send a AXFR request to primary DNS server
 2. the primary server responses a SOA records to check data updated
 3. the primary server transfer sequentially DNS records like A, AAAA, MX, CNAME,...
 4. the primary server notifies the transfer accomplished
 5. the secondary server send a confirm package (ACK)

### Implementation
The Zone Transfer Vulnerability: is a DNS misconfiguration that allow anyone (instead of reliable servers) send an AXFR requests and fetch wholesale copy of all DNS records, the hackers can get all info about sudomains (stagging, production, dev,...), IP addresses, name servers information... by using `dig axfr` cmd
```bash
# dig axfr @[nameserver IP/domain] [target IP]
```
ex:
```bash
# dig axfr @nsztm1.digi.ninja zonetransfer.me
```
## Remediation
Configurate the DNS servers that only allows strictly requests from a whitelist of trusted servers 

# Virtual Host (VHOST)
## Defination
VHOST is a configuration on Web servers (Apache, Nginx, IIS,...) allows multi website/applications running on only 1 IP address. Website will rely on HTTP Host Header in request to know exactly IP address target, then redirect to DocumentRoot (eg. /var/www/html). VHOST doesn't have DNS public records, whereas subdomain does. VHOST can only access internally by configuration via hosts file. There are some type of VHOST:
 1. Name-Based: use the samne IP, distinguish by Host Header.
 2. IP-Based: each webiste has its own IP address.
 3. Port-Based: use identical IP address, but has own port service (ex: port 80, 8080, 3000...)
## Tools (VHOST Fuzzing)
 - Gobuster
   ```bash
   # gobuster vhost -u http://<Target_IP> --domain <domain_name> -w <Path_to_Wordlist> --append-domain
   ex:
   # gobuster vhost -u http://1.2.3.4 --domain test.test -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt --append-domain [-o output.txt]
   ```
 - Forexbuster
 - ffuf
   ```bash
   # ffuf -u http://94.237.57.211:46627 \
     -H "Host: FUZZ.<domain>" \
     -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt \
     -fs 116
   ```
# Certificate Tranparency (CT) LOGS
## Tools
### crt.sh
Query and get JSON result:

```bash
# curl -s "https://crt.sh/?q=[domain_name]&output=json"
```

```bash
# curl -s "https://crt.sh/?q=[domain_name]&output=json" | jq -r '.[] | "\(.name_value)\n\(.common_name)"' | sort -u
```

Filter & extract subdomain list
```bash
# curl -s "https://crt.sh/?q=inlanefreight.com&output=json" | jq -r '.[] | "\(.name_value)\n\(.common_name)"' | sort -u
```

# Web Fingerprinting
## Banner Grabbing
Use curl cmd to fetch HTTTP header which may leak some tech stack info
```bash
# curl -I [domain/ip]
```
Note: if domain redirect to another, keep using the curl -I cmd with the new one until getting info

## WAF Detection
use `wafw00f` tool to investigate target domain/ip whether using WAF or not. This way help you to head up to be blocked before scanning
### Installation
```bash
# pip3 install git+https://github.com/EnableSecuirty/wafw00f
```
### How to use
```bash
# wafw00f [domain/ip]
```
### Web server scanning
USe `Nikto` to deeply scan to web server configuration to find out sensitive files, obsolete version, vulnerable config error
### Installation
```bash
# sudo apt update && sudo apt install -y perl
# git clone https://github.com/sullo/nikto
# cd nikto/program
# chmod +x ./nikto.pl
```
### How to use
```bash
# nikto -h [domain/ip] -Tuning b
```
Explanation:
-h: identify host
-Tuning b: important option, 'b' option instructs Nikto only run neccessary modules, which identifies softwares/tools/tech stacks, ignore the rest (such as SQLi, XSS,...) to reduce time and noise by WAF.

# Well-known URI
1. /robot.txt: allow/disallow path for crawling robots
2. /.well-known/security.txt: contains contact info of security team
3. /.well-known/change-password: standard path direct to change password page
4. /.well-known/openid-configuration: OpenID Connect config - identify layer in OAuth 2.0 (IMPORTANCE), it returns JSON format contains entire delegation of authority map of system. From this json, we can exploit `authorization_endpoint`, `token_endpoint`, `userinfo_endpoint` URLs, JWKS URI (`jwks_uri`), `scopes_supported`, `id_token_signing_alg_values_supported`
5. /.well-known/assetlinks.json: verify link connection between mobile and webapp
6. /.well-known/mta-sts.txt: SMTP MTA Strict Transport Security configuration, enhance and security check for Mail system

# Web crawling by Scrapy (Creepy Crawlies)
## Tools
1. Burp Suite Spider
2. OWASP ZAP (Opensource)
3. Scrapy (Python)
4. Apache Nutch (Java)
## How to install
```bash
# pip3 install scrapy
# wget -O ReconSpider.zip https://academy.hackthebox.com/storage/modules/144/ReconSpider.v1.2.zip
# unzip ReconSpider.zip
```
## How to use
```bash
# python3 ReconSpider.py [domain/ip]
```
## Analysis result.json
- emails: leaked emails
- links: internal/external links (web map)
- external_files: PDF/words... files (senstive data, metadata leak)
- js_files: javascript files, contains logic code, API keys, hidden endpoints
- comments: notes by developers, may contains password...

# Search Engine Discovery (Google Dorking/Google Hacking)
A technique to get sensitive info, hidden pages, vulnerability, configuration by using advance features and operator of search engine (google, bing,...) as OSNIT, which is free and legal. There are some google operators:
- site:[domain] : limit result with a specific domain
- inurl:[keyword] : find out page which has keyword
- filetype:[pdf] or ext:[pdf]: find out particular extension files
- intitle:"index of" : find out pages having title has keyword
- intext:"password reset" : findout keyword having in the page content
- cache:[domain] : checkout the cached of page by google captured
- site:[domain] -inurl:www : exclude result in the -inurl operator
- "[keywords]" : find out exactly keywords
## Examples
1. Search admin page and hidden login 
```bash
site:examplecom (inurl:login OR inurl:admin) OR inurl:dashboard)
```
2. Hunting Exposed Hidden files
```bash
site:example.com (filetype:pdf OR filetype:xls OR filetype:docx OR filetype:txt)
```
3. Search config system file - may leak password
```bash
site:exmaple.com inurl:config.php
site:example (ext:conf OR ext:cnf OR ext:ini)
``` 
4. Locate backup files and database backup
```bash
site:example.com inurl:backup
site:example.com filetype:sql
```

# Web Archinve
Wayback machine (web.archive.org) allows use to view websites snapshots/captures with specific time in the past

# Automating Recon
## Benefits:
- Efficiency: do schedule tasks faster
- Scalability: Scan huge targes and domain at the same time
- Consistency: Reduce humanility glitch
- Comprehensive Coverage
## Popular Automating Reconnaissance Frameworks
- FinalRecon (python): powerful, check http header, ssl, whois, crawling, subdomains
- Recon-ng (python): UI same as Metasploit, comprehensive reconnaissance
- theHarvester: collect email, subdomains, employee names, ports from OSINT sources such as google, shodan
- SpiderFoot: Automating OSINT tools, integrated with bunch of data source to collect IP, domain, social network
- OSINT Framework
## How to install FinalRecon
```bash
git clone https://github.com/thewhiteh4t/FinalRecon.git
cd FinalRecon
pip3 install -r requirements.txt
chmod +x ./finalrecon.py
```
## How to use FinalReon
```bash
./finalrecon.py --headers --whois --url http://inlanefreight.com
```
Note: default result file stores in path ~/.local/share/finalrecon/dumps/
