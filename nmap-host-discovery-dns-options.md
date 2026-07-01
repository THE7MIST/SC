# Nmap Host Discovery (Ping Scanning) & DNS Options

## Complete Study Notes

**Target Network:** `192.168.74.0/24`  
**Target Host:** `192.168.74.130`

---

# Understanding Host Discovery

Before Nmap begins scanning ports, it normally tries to answer one question:

> **"Is the target host alive?"**

This process is called **Host Discovery** or **Ping Scanning**.

If Nmap believes a host is offline, it **skips port scanning**, making the scan much faster.

However, many organizations block ICMP packets using firewalls, so Nmap provides multiple alternative methods to determine whether a host is alive.

---

# 1. Skip Host Discovery (`-Pn`)

## Command

```bash
nmap -Pn 192.168.74.130
```

Scan an entire subnet:

```bash
nmap -Pn 192.168.74.0/24
```

## What it does

Normally Nmap performs host discovery first.

```text
Ping Host
      ↓
Alive?
      ↓
Port Scan
```

With **`-Pn`**, Nmap completely skips this step.

It assumes:

> "The target is alive."

and immediately starts scanning ports.

## Internal Working

Instead of:

```text
Host Discovery
      ↓
Port Scan
```

it becomes:

```text
Port Scan Immediately
```

No:

- ICMP
- TCP Ping
- ARP Discovery

## When to use

Use `-Pn` when:

- Firewalls block ping requests
- ICMP is disabled
- You already know the target exists
- During penetration testing against hardened servers

### Example

```text
Company Firewall

Your PC
      |
ICMP Request
      |
Firewall Drops Packet
      |
Server

Without -Pn
↓

Nmap thinks host is down.

With -Pn
↓

Nmap scans ports anyway.
```

## Advantages

- Works even when ping is blocked.
- Finds services behind restrictive firewalls.
- Prevents false "Host seems down" messages.

## Disadvantages

Since Nmap assumes every IP is alive,

Scanning:

```text
192.168.74.0/24
```

means all **254 addresses** are scanned.

This is slower.

---

# 2. Ping Scan Only (`-sn`)

> Modern replacement for the older `-sP`.

## Command

```bash
nmap -sn 192.168.74.130
```

Network scan:

```bash
nmap -sn 192.168.74.0/24
```

## What it does

Checks which hosts are online.

It **does not scan ports.**

Result:

```text
Host A → Alive

Host B → Alive

Host C → Down
```

## Internal Working

Nmap performs only host discovery.

- No TCP Connect
- No SYN Scan
- No Service Detection

## When to use

Before scanning an entire subnet.

Instead of:

```text
Scan 254 machines
```

First discover:

```text
Alive:

192.168.74.5
192.168.74.20
192.168.74.130
```

Then scan only the live systems.

## Linux Root Behavior

If executed as **root** on a local LAN,

Nmap automatically performs:

```text
ARP Discovery
```

instead of ICMP because ARP is more reliable.

---

# 3. TCP SYN Ping (`-PS`)

## Command

Default (Port 80)

```bash
nmap -PS 192.168.74.130
```

Specify ports

```bash
nmap -PS22,80,443 192.168.74.130
```

## What it does

Instead of ICMP,

Nmap sends:

```text
TCP SYN
```

to the specified port.

## Possible Responses

### Port Open

```text
You
 |
SYN
 |
Target
 |
SYN ACK
```

Host is alive.

### Port Closed

```text
SYN
 ↓
RST
```

Still means the host is alive.

### No Response

```text
Packet Dropped
```

Host may be filtered.

## Why use it?

Many companies block:

```text
ICMP
```

but allow:

```text
HTTP (80)

HTTPS (443)

SSH (22)
```

TCP SYN Ping works well in those environments.

---

# 4. TCP ACK Ping (`-PA`)

## Command

```bash
nmap -PA 192.168.74.130
```

Specific ports

```bash
nmap -PA80,443 192.168.74.130
```

## What it does

Instead of sending SYN,

Nmap sends:

```text
TCP ACK
```

## Expected Reply

Since no connection exists,

Target replies:

```text
RST
```

which confirms the host is alive.

## When useful

When firewalls treat ACK packets differently than SYN packets.

---

# 5. UDP Ping (`-PU`)

## Command

Default

```bash
nmap -PU 192.168.74.130
```

Specific ports

```bash
nmap -PU53,161 192.168.74.130
```

## Default Port

If none specified:

```text
40125
```

## What it does

Sends UDP packets.

Looks for:

```text
ICMP Port Unreachable
```

or

```text
UDP Response
```

## Useful when

TCP traffic is filtered.

Common against:

- DNS
- NTP
- SNMP
- VoIP

---

# 6. SCTP INIT Ping (`-PY`)

## Command

```bash
nmap -PY 192.168.74.130
```

Specify ports

```bash
nmap -PY80 192.168.74.130
```

## What it does

Uses:

```text
SCTP INIT
```

instead of TCP.

## Common Uses

- IP Telephony
- Telecom Networks
- Signaling Systems
- LTE Infrastructure

## Rarely Used

Most enterprise LANs don't use SCTP.

---

# 7. ICMP Echo Ping (`-PE`)

## Command

```bash
nmap -PE 192.168.74.130
```

## What it does

Sends:

```text
ICMP Echo Request
```

Equivalent to:

```text
ping
```

command.

## Default Behavior

If no ping type is specified,

Nmap automatically uses:

```text
-PE
```

when applicable.

## Best For

- LAN
- Internal Networks
- Home Networks

## Weakness

Most Internet firewalls block ICMP.

---

# 8. ICMP Timestamp Ping (`-PP`)

## Command

```bash
nmap -PP 192.168.74.130
```

## What it does

Sends:

```text
ICMP Timestamp Request
```

instead of Echo Request.

## Why?

Some firewalls block:

```text
Echo
```

but forget to block:

```text
Timestamp
```

Useful for discovering improperly configured systems.

---

# 9. ICMP Address Mask Ping (`-PM`)

## Command

```bash
nmap -PM 192.168.74.130
```

## What it does

Uses:

```text
ICMP Address Mask Request
```

instead of Echo.

## Purpose

Attempts to bypass firewalls that block normal ICMP Echo packets but allow older ICMP message types.

## Modern Relevance

Very uncommon today because most operating systems ignore Address Mask requests.

---

# 10. IP Protocol Ping (`-PO`)

## Command

Default protocols

```bash
nmap -PO 192.168.74.130
```

Specific protocols

```bash
nmap -PO1,2,4 192.168.74.130
```

## Default Protocols

| Protocol Number | Protocol |
|-----------------|----------|
| 1 | ICMP |
| 2 | IGMP |
| 4 | IP-in-IP |

## What it does

Instead of sending TCP or ICMP,

Nmap sends packets using specific IP protocol numbers to determine whether the host is alive.

## Used In

- Advanced network testing
- Protocol filtering analysis
- Firewall testing

---

# 11. ARP Ping (`-PR`)

## Command

```bash
nmap -PR 192.168.74.130
```

Network

```bash
nmap -PR 192.168.74.0/24
```

## What it does

Uses:

```text
ARP Request

Who has 192.168.74.130?
```

Target replies:

```text
192.168.74.130 is at

08:00:27:xx:xx:xx
```

## Why ARP is Powerful

ARP operates at **OSI Layer 2 (Data Link Layer).**

Firewalls generally cannot filter normal ARP communication on the local subnet.

## Limitation

Works **only on the local network.**

Cannot cross routers.

---

# 12. Trace Route (`--traceroute`)

## Command

```bash
nmap --traceroute 192.168.74.130
```

## Purpose

Shows every router (hop) between you and the destination.

Example:

```text
Your PC
   ↓
Router
   ↓
Firewall
   ↓
Gateway
   ↓
Server
```

Useful for:

- Troubleshooting
- Path analysis
- Identifying network bottlenecks

---

# 13. Force Reverse DNS (`-R`)

## Command

```bash
nmap -R 192.168.74.130
```

Network

```bash
nmap -R 192.168.74.0/24
```

## What it does

Normally Nmap performs reverse DNS lookups **only for hosts detected as alive.**

With `-R`, Nmap attempts reverse DNS resolution for **every IP address**, even if it appears offline.

## Why use it

Can reveal hostnames such as:

```text
192.168.74.10  → fileserver.local
192.168.74.20  → backup.local
192.168.74.130 → metasploitable.local
```

Useful during reconnaissance, but increases scan time.

---

# 14. Disable Reverse DNS (`-n`)

## Command

```bash
nmap -n 192.168.74.130
```

Network

```bash
nmap -n 192.168.74.0/24
```

## What it does

Disables all reverse DNS lookups.

Results display only IP addresses.

## When to use

- Large subnet scans
- Time-sensitive assessments
- When hostnames are unnecessary

---

# 15. Use System DNS Resolver (`--system-dns`)

## Command

```bash
nmap --system-dns 192.168.74.130
```

## What it does

Uses the operating system's DNS resolver instead of Nmap's internal resolver.

## When useful

- Troubleshooting DNS resolution
- Matching operating system DNS behavior
- IPv6 scans

## Drawback

Usually slower than Nmap's built-in resolver.

---

# 16. Specify Custom DNS Servers (`--dns-servers`)

## Command

Single DNS server

```bash
nmap --dns-servers 8.8.8.8 192.168.74.130
```

Multiple DNS servers

```bash
nmap --dns-servers 8.8.8.8,1.1.1.1 192.168.74.130
```

## What it does

Overrides the system-configured DNS servers and uses the specified DNS servers for hostname resolution.

## Why use it

- Local DNS server unavailable
- Compare DNS responses
- Avoid default organizational DNS during authorized testing

---

# Summary Table

| Option | Purpose | Default Behavior / Notes |
|---------|---------|--------------------------|
| `-Pn` | Skip host discovery | Assume host is alive and scan directly |
| `-sn` | Host discovery only | No port scan (replaces `-sP`) |
| `-PS` | TCP SYN Ping | Default port 80 |
| `-PA` | TCP ACK Ping | Useful when SYN is filtered |
| `-PU` | UDP Ping | Default UDP port 40125 |
| `-PY` | SCTP INIT Ping | Default SCTP port 80 |
| `-PE` | ICMP Echo Ping | Default ICMP method |
| `-PP` | ICMP Timestamp Ping | Can bypass poorly configured firewalls |
| `-PM` | ICMP Address Mask Ping | Legacy ICMP method |
| `-PO` | IP Protocol Ping | Default protocols: 1, 2, 4 |
| `-PR` | ARP Ping | Automatic on local Ethernet networks |
| `--traceroute` | Trace packet path | Shows intermediate hops |
| `-R` | Force reverse DNS | Resolve all IPs |
| `-n` | Disable reverse DNS | Faster scans |
| `--system-dns` | Use OS DNS resolver | Useful for troubleshooting |
| `--dns-servers` | Use custom DNS servers | Overrides system DNS |

---

# Key Takeaways

- Host Discovery determines whether a target is alive before port scanning.
- `-Pn` skips host discovery and assumes every target is online.
- `-sn` performs host discovery only and does not scan ports.
- TCP, UDP, ICMP, SCTP, ARP, and IP Protocol pings provide alternative methods to detect live hosts.
- ARP Ping (`-PR`) is the most reliable method on local Ethernet networks.
- `-R`, `-n`, `--system-dns`, and `--dns-servers` control how Nmap performs DNS resolution.
- `--traceroute` identifies every hop between the scanner and the destination.

---

> **Note:** These notes use the **current Nmap syntax** (e.g., `-sn` instead of the deprecated `-sP`) while preserving all concepts discussed in the original material.
