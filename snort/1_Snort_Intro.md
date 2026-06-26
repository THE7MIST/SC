# Snort Master Notes (Concepts Only)

> **Rules, installation, configuration, and practical labs are intentionally excluded.**

---

# Table of Contents

1. [What is an IDS?](#1-what-is-an-ids)
2. [IDS vs IPS](#2-ids-vs-ips)
3. [Types of IDS](#3-types-of-ids)
4. [Detection Techniques](#4-detection-techniques)
5. [What is Snort?](#5-what-is-snort)
6. [Features of Snort](#6-features-of-snort)
7. [Snort Architecture](#7-snort-architecture)
8. [Operational Modes](#8-operational-modes)
9. [Snort Components](#9-snort-components)
10. [Snort Versions](#10-snort-versions)
11. [Snort Rule Sources](#11-snort-rule-sources)
12. [Common Threats Detected](#12-common-threats-detected)
13. [Advantages](#13-advantages)
14. [Limitations](#14-limitations)
15. [Real-World Deployment](#15-real-world-deployment)
16. [Key Terms](#16-key-terms)
17. [Interview & Exam Quick Revision](#17-interview--exam-quick-revision)

---

# 1. What is an IDS?

An **Intrusion Detection System (IDS)** is a security solution that continuously monitors network or host activities to detect malicious behavior, policy violations, and cyber attacks.

Unlike an IPS, an IDS **does not stop attacks**. It only **detects**, **logs**, and **alerts** administrators.

## Primary Objectives

- Detect unauthorized access
- Identify attacks in real time
- Log malicious activities
- Generate alerts
- Assist in digital forensics

---

# 2. IDS vs IPS

| IDS | IPS |
|-----|-----|
| Detects attacks | Detects and blocks attacks |
| Passive security | Active security |
| Generates alerts | Drops or rejects malicious packets |
| Does not modify traffic | Can block or modify traffic |
| Used for monitoring | Used for prevention |

> **Exam Tip:** Every IPS performs IDS functions, but an IDS cannot prevent attacks.

---

# 3. Types of IDS

## A. Host-Based IDS (HIDS)

Installed on an individual computer or server.

### Monitors

- System logs
- Running processes
- File integrity
- Windows Registry
- User activities

### Advantages

- Detects insider attacks
- Monitors encrypted traffic after decryption
- Detailed host visibility

### Disadvantages

- Protects only one host
- Consumes host resources
- Must be installed on every endpoint

### Examples

- OSSEC
- Wazuh
- Tripwire

---

## B. Network-Based IDS (NIDS)

Installed at strategic points in a network to inspect packets flowing between devices.

### Monitors

- Network packets
- Protocols
- Sessions
- Traffic behavior

### Advantages

- Protects multiple hosts
- Centralized monitoring
- No endpoint installation required

### Disadvantages

- Cannot inspect encrypted payloads
- Requires powerful hardware for high-speed networks

### Examples

- Snort
- Suricata
- Zeek

---

# 4. Detection Techniques

## A. Signature-Based Detection

Compares network traffic against a database of known attack signatures.

### Example

```text
Known SQL Injection
Known Nmap Scan
Known Malware
```

### Advantages

- Fast
- Accurate
- Low false positives

### Disadvantages

- Cannot detect unknown attacks
- Requires frequent signature updates

---

## B. Anomaly-Based Detection

Learns normal network behavior and alerts when unusual activity occurs.

### Example

```text
Normal SSH Logins = 5/day

Today = 500

Alert Generated
```

### Advantages

- Detects zero-day attacks
- Detects unknown threats

### Disadvantages

- Higher false positives
- Requires a learning period

---

## C. Behavior-Based Detection

Detects attacks by analyzing long-term behavioral patterns rather than fixed signatures.

---

# 5. What is Snort?

**Snort** is a free and open-source **Network Intrusion Detection System (NIDS)** that can also function as an **Intrusion Prevention System (IPS)** when deployed in **Inline Mode**.

- Developed by **Martin Roesch** in **1998**
- Currently maintained by **Cisco Talos**

---

# 6. Features of Snort

- Real-time packet capture
- Deep Packet Inspection (DPI)
- Protocol analysis
- Signature-based detection
- Content matching
- Packet logging
- Alert generation
- Custom rule support
- Community rule support
- Inline IPS capability
- IPv4 & IPv6 support
- Multi-threading (Snort 3)

---

# 7. Snort Architecture

```text
Network
   │
   ▼
Packet Capture
   │
   ▼
Packet Decoder
   │
   ▼
Preprocessors
   │
   ▼
Detection Engine
   │
   ▼
Output Modules
```

## Packet Capture

Responsible for:

- Capturing packets
- Forwarding packets to Snort

---

## Packet Decoder

Recognizes and decodes protocols including:

- Ethernet
- IPv4
- IPv6
- TCP
- UDP
- ICMP
- ARP

---

## Preprocessors

Prepare packets before inspection.

Functions include:

- TCP Stream Reassembly
- IP Fragment Reassembly
- Protocol Normalization
- HTTP Inspection
- Portscan Detection

---

## Detection Engine

The core of Snort.

Responsibilities:

- Compare packets with signatures
- Analyze protocol fields
- Inspect packet payloads
- Generate alerts

---

## Output Modules

Responsible for:

- Alerts
- Packet logging
- JSON output
- Syslog
- SIEM integration

---

# 8. Operational Modes

## 1. Sniffer Mode

Displays captured packets on the screen.

Uses:

- Troubleshooting
- Packet inspection
- Learning networking

---

## 2. Packet Logger Mode

Stores packets in log files.

Uses:

- Traffic analysis
- Incident investigation
- Packet replay

---

## 3. IDS Mode

Analyzes packets using predefined rules.

If a rule matches:

- Alert generated
- Event logged

Traffic is **not blocked**.

---

## 4. IPS (Inline) Mode

Traffic passes through Snort.

If malicious traffic matches:

- Packet dropped
- Packet rejected
- Connection terminated

---

# 9. Snort Components

| Component | Function |
|-----------|----------|
| Packet Capture | Captures packets |
| Packet Decoder | Decodes protocols |
| Preprocessors | Normalize traffic |
| Detection Engine | Detects attacks |
| Output Modules | Logs and alerts |

---

# 10. Snort Versions

## Snort 2.x

- Legacy version
- Stable
- Widely used in older labs
- Uses `snort.conf`

---

## Snort 3.x

Current generation of Snort.

### Improvements

- Multi-threading
- Better performance
- Better scalability
- Improved plugin architecture
- Lua configuration (`snort.lua`)

> **Note:** Snort 3.x is recommended for new deployments. Snort 2.x is still commonly used in labs and legacy environments.

---

# 11. Snort Rule Sources

## Community Rules

- Free
- Maintained by the Snort community

## Registered Rules

- Free after registration
- Maintained by Cisco Talos

## Subscriber Rules

- Paid subscription
- Latest signatures

## Custom Rules

- Created by administrators
- Organization-specific

---

# 12. Common Threats Detected

- Port Scanning
- SSH Brute Force
- SQL Injection
- Cross-Site Scripting (XSS)
- Buffer Overflow
- Malware Communication
- DNS Attacks
- ICMP Abuse
- FTP Attacks
- HTTP Attacks
- SMB Attacks
- Worm Activity
- Command & Control (C2)

---

# 13. Advantages

- Free and Open Source
- Large community
- Frequently updated rules
- Highly customizable
- Lightweight
- Real-time detection
- Supports IDS and IPS
- Easy SIEM integration

---

# 14. Limitations

- Mainly signature-based
- Requires regular rule updates
- Limited encrypted traffic inspection
- False positives if poorly tuned
- Requires good hardware for high-speed networks

---

# 15. Real-World Deployment

```text
             Internet
                 │
                 ▼
            Firewall
                 │
                 ▼
              Switch
        ┌────────┼────────┐
        │        │        │
     Servers   Clients  Snort Sensor
                          │
                          ▼
                    SIEM / SOC
```

## Workflow

1. Network traffic is mirrored to the Snort sensor.
2. Snort analyzes packets.
3. If malicious activity is detected:
   - Alert generated
   - Event logged
   - Forwarded to SIEM/SOC
4. In IPS mode, malicious packets are blocked.

---

# 16. Key Terms

| Term | Meaning |
|------|---------|
| IDS | Intrusion Detection System |
| IPS | Intrusion Prevention System |
| HIDS | Host-Based Intrusion Detection System |
| NIDS | Network-Based Intrusion Detection System |
| DPI | Deep Packet Inspection |
| Signature | Pattern used to identify a known attack |
| Alert | Notification generated by Snort |
| Packet | Basic unit of network communication |
| Preprocessor | Normalizes packets before inspection |
| Detection Engine | Matches traffic against signatures |
| SIEM | Security Information and Event Management |

---

# 17. Interview & Exam Quick Revision

- IDS detects and alerts.
- IPS detects and blocks.
- HIDS protects a single host.
- NIDS protects an entire network.
- Snort is an open-source NIDS/IPS.
- Maintained by Cisco Talos.
- Snort Architecture:
  - Packet Capture
  - Packet Decoder
  - Preprocessors
  - Detection Engine
  - Output Modules
- Operational Modes:
  - Sniffer
  - Packet Logger
  - IDS
  - IPS (Inline)
- Snort 3.x is the recommended version.
- Snort primarily uses signature-based detection.

---

**End of Chapter 1**
