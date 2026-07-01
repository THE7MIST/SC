# Burp Suite Terminologies (Detailed Beginner Reference)

Burp Suite is one of the most widely used tools for **Web Application Penetration Testing (WAPT)**. It acts as an **intercepting proxy**, allowing security testers to inspect, modify, replay, and analyze HTTP/HTTPS traffic between a client (browser) and a web server.

The following terminology covers the concepts that every beginner should know before performing web application security testing.

---

# 1. Proxy

## GUI Location

```text
Proxy
```

## Definition

A **Proxy** is an intermediary that sits between your browser and the target web application.

Instead of your browser communicating directly with the server, every request and response passes through Burp Suite first.

```text
Without Burp

Browser -----------------> Server


With Burp

Browser -----> Burp Proxy -----> Server
                   ↑
            Inspect / Modify
```

## Purpose

The Proxy allows you to:

* Capture traffic
* View requests
* View responses
* Modify data
* Replay requests
* Understand application behavior

## Typical Uses

* Authentication testing
* Parameter manipulation
* API testing
* Learning HTTP

---

# 2. Intercept

## GUI Location

```text
Proxy
    └── Intercept
```

## Definition

Intercept temporarily **stops an HTTP/HTTPS request or response** before it reaches its destination.

Think of it as pressing the **Pause button** on web traffic.

```text
Browser

      │
      ▼

Burp
(Request Stopped)

      │
      ▼

Server
```

## Main Buttons

### Intercept is ON

Captures requests.

Every request pauses until you decide what to do.

---

### Intercept is OFF

Traffic passes normally.

Nothing is paused.

---

### Forward

Allows the request to continue.

```text
Browser

↓

Burp

↓

Server
```

Use when:

* Finished inspecting
* Finished editing
* Want normal communication

---

### Drop

Deletes the request.

```text
Browser

↓

Burp

X

Server
```

Server never receives it.

Useful for:

* Canceling logout requests
* Preventing account deletion
* Testing client-side validation

---

### Action

Provides additional options:

* Send to Repeater
* Send to Intruder
* Send to Decoder
* Send to Comparer
* Save Item
* Copy URL
* Copy Request
* Copy Response

---

# 3. HTTP History

## GUI Location

```text
Proxy

└── HTTP History
```

## Definition

HTTP History stores **every HTTP and HTTPS request and response** Burp captures.

It acts like a recording of your browsing session.

Example

```text
GET /login

POST /login

GET /dashboard

GET /profile

POST /changePassword
```

Everything remains available even if you forgot to intercept it.

---

## Information Stored

Each entry includes:

* Method
* URL
* Status Code
* MIME Type
* Host
* Response Length
* Time
* Request
* Response

---

## Why It Is Important

During testing you often need to:

* Repeat requests
* Compare responses
* Send previous requests to Repeater
* Send previous requests to Intruder

Instead of recreating them manually.

---

## Clearing History

Inside HTTP History

```text
Right Click

↓

Clear History
```

or

```text
Ctrl + A

Delete
```

(depending on Burp version)

---

# 4. Request

## Definition

A Request is the data sent by the browser to the server.

Example

```http
GET /login HTTP/1.1

Host: example.com

User-Agent: Chrome

Cookie: session=abc123
```

A request tells the server:

* Which page is needed
* Which API should execute
* Who the user is
* What data is submitted

---

## Common Request Components

* Request Line
* Headers
* Body

---

# 5. Response

## Definition

The Response is the data returned by the server.

Example

```http
HTTP/1.1 200 OK

Content-Type: text/html

<html>

Welcome Admin

</html>
```

A response contains:

* Status code
* Headers
* Cookies
* HTML
* JSON
* XML
* Images

---

# 6. HTTP Methods

## Where Visible

* Proxy
* Repeater
* HTTP History

## Definition

HTTP Methods define what action should be performed.

### GET

Retrieves information.

Example

```text
GET /profile
```

No request body.

Safe and idempotent.

---

### POST

Sends data.

Example

```text
POST /login
```

Usually contains username and password.

---

### PUT

Updates or replaces a resource.

Example

```text
PUT /api/user/5
```

---

### PATCH

Partially updates data.

Example

```text
PATCH /api/profile
```

---

### DELETE

Deletes a resource.

Example

```text
DELETE /user/15
```

---

### OPTIONS

Returns supported HTTP methods.

Often used during CORS.

---

### HEAD

Returns only headers.

No response body.

Useful for checking resource availability.

---

# 7. URL

Example

```text
https://example.com/login?id=10
```

A URL consists of:

```text
https://
Protocol

example.com
Domain

/login
Path

?id=10
Parameter
```

---

# 8. Parameters

Parameters are values sent to the application.

Example

```text
?id=10
```

or

```text
username=admin
```

or JSON

```json
{
"name":"John"
}
```

## Types

### URL Parameters

```text
?id=10
```

---

### Body Parameters

```text
username=admin
```

---

### JSON Parameters

```json
{
"role":"admin"
}
```

---

### Cookie Parameters

```text
Cookie:

session=abc
```

Most vulnerabilities originate from parameter manipulation.

---

# 9. Headers

Headers contain metadata.

Example

```http
Host:

User-Agent:

Cookie:

Authorization:

Accept:

Referer:

Origin:

Content-Type:
```

Headers tell the server:

* Browser type
* Session information
* Authentication
* Accepted content
* Request origin

---

# 10. Body

The body contains submitted data.

Example

```text
username=admin

password=admin123
```

or

```json
{
"username":"admin",
"password":"admin123"
}
```

Mostly appears in:

* POST
* PUT
* PATCH

---

# 11. Cookies

Cookies are small pieces of information stored by the browser.

Request

```http
Cookie:

session=abc123
```

Response

```http
Set-Cookie:

session=abc123
```

## Uses

* Authentication
* Sessions
* User preferences
* Tracking

---

# 12. Session

A session identifies a logged-in user.

Common names

```text
PHPSESSID

JSESSIONID

ASP.NET_SessionId

connect.sid
```

Without a valid session cookie, the server treats you as a new user.

---

# 13. Scope

## GUI Location

```text
Target

↓

Scope
```

Scope tells Burp:

> Which domains should Burp focus on?

Useful during:

* Bug bounty
* Pentests
* Large applications

Anything outside scope can be ignored.

---

# 14. Target

## GUI Location

```text
Target
```

Shows discovered hosts.

Example

```text
example.com

|

+ login

+ admin

+ profile

+ images

+ api
```

Provides a tree view of the application.

---

# 15. Site Map

## GUI Location

```text
Target

↓

Site Map
```

Automatically discovers:

* Directories
* APIs
* Images
* JavaScript files
* CSS files
* HTML pages

Useful for understanding the application's attack surface.

---

# 16. Repeater

## GUI Location

```text
Repeater
```

Probably the most-used Burp tool.

## Purpose

Allows manual testing of one request repeatedly.

Workflow

```text
Send Request

↓

Edit

↓

Send Again

↓

Edit

↓

Send Again
```

Perfect for:

* SQL Injection
* XSS
* IDOR
* Authentication bypass
* API testing

---

# 17. Send to Repeater

Right-click any request.

```text
Right Click

↓

Send to Repeater
```

Shortcut

```text
Ctrl + R
```

Allows manual experimentation without using the browser.

---

# 18. Intruder

## GUI Location

```text
Intruder
```

Intruder automates sending many modified requests.

Instead of manually changing values one by one, Intruder performs it automatically.

Uses include:

* Input fuzzing
* Parameter discovery
* Payload testing
* Security testing in authorized environments

---

# 19. Positions

Inside Intruder.

Marks insertion points.

Example

```text
password=§admin§
```

Everything between

```text
§ §
```

changes automatically.

---

# 20. Payload

Payloads are values Intruder inserts.

Example

```text
admin

root

guest

test

administrator
```

Each payload creates a new request.

---

# 21. Attack Types

Inside Intruder.

### Sniper

One parameter changes.

---

### Battering Ram

Same payload inserted everywhere.

---

### Pitchfork

Multiple payload lists move together.

---

### Cluster Bomb

Every payload combination.

Largest number of requests.

---

# 22. Decoder

## GUI Location

```text
Decoder
```

Converts data.

Supports:

* Base64
* URL Encoding
* HTML Encoding
* Hex
* Binary

Example

```text
YWRtaW4=

↓

admin
```

Very useful during API testing.

---

# 23. Comparer

## GUI Location

```text
Comparer
```

Compares:

* Two requests
* Two responses

Useful when changes are very small.

Example:

Compare:

```text
User Response
```

vs

```text
Admin Response
```

---

# 24. Logger

## GUI Location

```text
Logger
```

Records Burp activity.

Useful for:

* Troubleshooting
* Debugging
* Reviewing requests

---

# 25. Inspector

Located on the right side of many Burp tools.

Instead of raw HTTP,

Inspector categorizes data.

Example

```text
Headers

Cookies

URL

Parameters

JSON

XML

Multipart

Authorization
```

Makes requests easier to understand.

---

# 26. Raw View

Shows the original HTTP request exactly as transmitted.

Example

```http
POST /login HTTP/1.1

Host:

Cookie:

User-Agent:
```

Used when precise editing is required.

---

# 27. Pretty View

Formats data automatically.

Supports:

* JSON
* XML
* HTML

Instead of:

```json
{"id":1,"name":"John"}
```

You'll see:

```json
{
  "id":1,
  "name":"John"
}
```

Much easier to analyze.

---

# 28. WebSockets History

## GUI Location

```text
Proxy

↓

WebSockets History
```

Stores WebSocket messages.

Unlike HTTP,

WebSockets maintain a continuous two-way connection.

Used in:

* Chat applications
* Online games
* Stock dashboards
* Notifications

---

# 29. TLS / HTTPS Interception

Modern websites use HTTPS.

Traffic is encrypted.

Burp cannot inspect encrypted traffic directly.

Burp solves this by acting as a trusted Certificate Authority (CA).

Flow

```text
Browser

↓

Burp Certificate

↓

Decrypt

↓

Inspect

↓

Encrypt Again

↓

Server
```

Without installing Burp's CA certificate:

* Browser shows certificate warning
* HTTPS interception fails

---

# 30. Forward vs Drop

Located inside

```text
Proxy

↓

Intercept
```

| Option  | Meaning          | Typical Use                              |
| ------- | ---------------- | ---------------------------------------- |
| Forward | Continue request | Normal browsing after inspection         |
| Drop    | Discard request  | Prevent request from reaching the server |

---

# Common Right-Click Actions

| Action             | Purpose                       |
| ------------------ | ----------------------------- |
| Send to Repeater   | Manual testing                |
| Send to Intruder   | Automated testing             |
| Send to Decoder    | Decode or encode values       |
| Send to Comparer   | Compare requests or responses |
| Copy URL           | Copy URL                      |
| Copy Request       | Copy raw request              |
| Copy Response      | Copy raw response             |
| Save Item          | Save request/response         |
| Add to Scope       | Include host in testing       |
| Exclude from Scope | Ignore host                   |

---

# Burp Suite GUI Layout

```text
+-----------------------------------------------------------------------+
| Dashboard | Target | Proxy | Intruder | Repeater | Decoder | Comparer |
| Logger | Organizer | Extensions | Settings                           |
+-----------------------------------------------------------------------+

Target
├── Site Map
└── Scope

Proxy
├── Intercept
├── HTTP History
└── WebSockets History

Intruder
├── Positions
├── Payloads
├── Attack Settings
└── Results

Repeater
├── Request
├── Response
└── Inspector

Decoder
├── Encode
├── Decode
└── Smart Decode
```

---

# Recommended Learning Order

1. Proxy
2. Intercept
3. HTTP History
4. Request & Response
5. HTTP Methods
6. URL & Parameters
7. Headers & Body
8. Cookies & Sessions
9. Target & Site Map
10. Scope
11. Repeater
12. Inspector
13. Decoder
14. Comparer
15. Intruder
16. WebSockets History
17. HTTPS Interception
18. Logger

Mastering these concepts provides a strong foundation for understanding Burp Suite's workflow and prepares you for more advanced topics such as authentication testing, API security testing, input validation analysis, and authorized web application security assessments.
