# 2_Snort_Rules_and_Network_Placement.md

# Snort Rules & Network Placement

> This chapter covers Snort rule syntax, rule structure, common rule options, rule actions, and IDS/IPS deployment in a network.

---

# Table of Contents

1. Snort Rule Syntax
2. Rule Structure
3. Rule Header
4. Rule Options
5. Common Rule Actions
6. Snort Rule Types
7. Sample Rules
8. Rule Processing Flow
9. IDS vs IPS Placement
10. Snort Network Placement
11. Best Practices
12. Interview & Exam Revision

---

# 1. Snort Rule Syntax

A Snort rule consists of **two parts**:

```
Rule Header + Rule Options
```

General Syntax

```text
action protocol source_ip source_port direction destination_ip destination_port (options)
```

Example

```text
alert icmp 192.168.1.10 any -> any any (msg:"ICMP Attempt"; sid:1000005; rev:1;)
```

---

# Rule Breakdown

```text
alert icmp 192.168.1.10 any -> any any (msg:"ICMP Attempt"; sid:1000005;)
│      │       │          │    │   │    │
│      │       │          │    │   │    └── Rule Options
│      │       │          │    │   └──── Destination Port
│      │       │          │    └──────── Destination Address
│      │       │          └───────────── Direction
│      │       └──────────────────────── Source Port
│      └──────────────────────────────── Source Address
└─────────────────────────────────────── Action + Protocol
```

---

# 2. Rule Structure

Every rule has:

## Rule Header

Defines

- Action
- Protocol
- Source
- Source Port
- Direction
- Destination
- Destination Port

---

## Rule Options

Everything inside parentheses.

Example

```text
(msg:"ICMP Attempt"; sid:1000005; rev:1;)
```

Rule options decide

- Alert message
- Rule ID
- Priority
- Payload matching
- TCP flags
- References
- Metadata

---

# 3. Rule Header

| Field | Description | Example |
|---------|-------------|---------|
| Action | What Snort should do | alert |
| Protocol | Network protocol | tcp, udp, icmp |
| Source IP | Packet source | any |
| Source Port | Source port | any |
| Direction | Packet direction | -> |
| Destination IP | Target IP | any |
| Destination Port | Destination Port | 80 |

---

## Action

Determines what Snort should do when the rule matches.

Possible values

- alert
- log
- pass
- drop
- reject
- sdrop

---

## Protocol

Can inspect

- TCP
- UDP
- ICMP
- IP
- ANY

---

## Source Address

Examples

```text
any

192.168.1.10

10.0.0.0/24
```

---

## Source Port

Examples

```text
80

22

443

any
```

---

## Direction Operators

### Unidirectional

```text
->
```

Traffic flows only one direction.

---

### Bidirectional

```text
<>
```

Traffic inspected both directions.

---

## Destination Address

Examples

```text
any

192.168.1.0/24
```

---

## Destination Port

Examples

```text
80

22

53

443

any
```

---

# 4. Rule Options

Everything inside

```
(...)
```

Example

```text
(msg:"Ping"; sid:1001; rev:1;)
```

---

## Common Rule Options

| Option | Purpose | Example |
|----------|----------|---------|
| msg | Alert message | msg:"HTTP Access"; |
| sid | Signature ID | sid:1000001; |
| rev | Rule revision | rev:1; |
| content | Match payload | content:"GET"; |
| nocase | Ignore case | nocase; |
| flags | TCP Flags | flags:S; |
| classtype | Attack classification | classtype:web-attack; |
| priority | Alert severity | priority:1; |
| reference | CVE or URL | reference:cve,2024-0001; |
| metadata | Extra information | metadata:policy balanced-ips; |
| gid | Generator ID | gid:1; |

---

## msg

Alert text shown when rule matches.

Example

```text
msg:"Possible Nmap Scan";
```

---

## sid

Unique Signature ID.

Every custom rule should have its own SID.

Example

```text
sid:1000005;
```

---

## rev

Rule revision.

Increase whenever rule changes.

```text
rev:2;
```

---

## content

Matches packet payload.

Example

```text
content:"GET";
```

---

## nocase

Case insensitive matching.

```text
content:"admin";
nocase;
```

Matches

```
admin

ADMIN

Admin
```

---

## flags

Checks TCP Flags.

Example

```text
flags:S;
```

Useful for

- SYN scans
- Nmap detection

---

## classtype

Categorizes attack.

Examples

```
attempted-admin

web-application-attack

trojan-activity

attempted-recon
```

---

## priority

Defines alert importance.

```
1 = High

2 = Medium

3 = Low
```

---

## reference

Adds

- CVE
- Bugtraq
- URL

Example

```text
reference:cve,2024-1234;
```

---

## metadata

Stores additional information.

Example

```text
metadata:policy balanced-ips;
```

---

# 5. Common Rule Actions

| Action | Description |
|---------|-------------|
| alert | Generate alert and log packet |
| log | Log packet only |
| pass | Ignore packet |
| drop | Drop packet (IPS only) |
| reject | Drop and send TCP Reset / ICMP |
| sdrop | Silent drop without logging |

---

# 6. Snort Rule Types

## Community Rules

- Free
- Maintained by community
- Good for learning

---

## Registered Rules

- Free after registration
- Maintained by Cisco Talos

---

## Subscriber Rules

- Paid
- Latest attack signatures
- Enterprise use

---

## Local / Custom Rules

Created by administrators.

Stored in

```
local.rules
```

---

# 7. Sample Rules

## HTTP Detection

```text
alert tcp any any -> any 80 (msg:"HTTP Access"; sid:100001; rev:1;)
```

---

## SSH Detection

```text
alert tcp any any -> any 22 (msg:"SSH Connection"; sid:100002; rev:1;)
```

---

## FTP Detection

```text
alert tcp any any -> any 21 (msg:"FTP Connection"; sid:100003; rev:1;)
```

---

## ICMP Ping

```text
alert icmp any any -> any any (msg:"ICMP Ping"; sid:100004; rev:1;)
```

---

## Nmap SYN Scan

```text
alert tcp any any -> any any (flags:S; msg:"Possible Nmap Scan"; sid:100005; rev:1;)
```

---

# 8. Rule Processing Flow

```text
Incoming Packet
        │
        ▼
Header Matching
        │
        ▼
Payload Matching
        │
        ▼
Rule Options Checked
        │
        ▼
Action Executed
        │
        ▼
Alert / Log / Drop
```

---

# 9. IDS vs IPS Placement

## IDS (Passive)

```text
Traffic
      │
      ▼
Switch
      │
      ├──── Normal Traffic
      │
      └──── Mirror/SPAN Port
                │
                ▼
            Snort IDS
```

### Characteristics

- Uses SPAN/TAP
- Receives copied traffic
- No impact on network
- Detects only
- Generates alerts

---

## IPS (Inline)

```text
Client
   │
   ▼
Switch
   │
   ▼
Snort IPS
   │
   ▼
Firewall
   │
   ▼
Router
   │
   ▼
Internet
```

### Characteristics

- Inline device
- All traffic passes through Snort
- Can block attacks
- Can reject packets
- Prevents malicious traffic

---

# 10. Snort Network Placement

## Passive IDS

- Connected using SPAN or TAP port
- Receives mirrored traffic
- Used for monitoring
- Does not affect performance

Best for

- SOC
- Monitoring
- Threat Hunting
- Forensics

---

## Inline IPS

Placed directly in traffic path.

Best for

- Data centers
- DMZ
- Enterprise edge
- Internet gateway

---

# IDS vs IPS Comparison

| Feature | IDS | IPS |
|-----------|-----|-----|
| Traffic Path | Outside | Inline |
| Detect | ✅ | ✅ |
| Alert | ✅ | ✅ |
| Block | ❌ | ✅ |
| Packet Drop | ❌ | ✅ |
| Traffic Impact | None | Possible |
| Deployment | SPAN/TAP | Inline |

---

# 11. Best Practices

- Use IDS for monitoring and visibility.
- Use IPS at the network perimeter.
- Keep rules updated regularly.
- Remove unnecessary rules.
- Tune rules to reduce false positives.
- Use custom rules for organization-specific threats.
- Monitor logs continuously.
- Integrate Snort with a SIEM.

---

# 12. Interview & Exam Quick Revision

- A Snort rule = **Header + Options**.
- Rule header defines **who, where, and protocol**.
- Rule options define **what to inspect and what action to take**.
- `msg` displays the alert message.
- `sid` uniquely identifies a rule.
- `rev` indicates the rule version.
- `content` matches payload data.
- `flags` detects TCP flag combinations (e.g., SYN scans).
- IDS is **Passive** and connected via **SPAN/TAP**.
- IPS is **Inline** and can **drop or reject** malicious packets.
- Common actions: **alert, log, pass, drop, reject, sdrop**.
- Snort processes packets by matching the header first, then evaluating rule options before executing the configured action.

---

**End of Chapter 2**
