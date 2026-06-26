````markdown
# 1_Snort_Intro.md

# Snort Master Notes (Concepts Only)


---

# Table of Contents

1. What is an IDS?
2. IDS vs IPS
3. Types of IDS
4. Detection Techniques
5. What is Snort?
6. Features of Snort
7. Snort Architecture
8. Operational Modes
9. Snort Components
10. Snort Versions
11. Snort Rule Sources
12. Common Threats Detected
13. Advantages
14. Limitations
15. Real-World Deployment
16. Key Terms
17. Interview & Exam Quick Revision

---

# 1. What is an IDS?

An **Intrusion Detection System (IDS)** is a security solution that continuously monitors network or host activities to detect malicious behavior, policy violations, and cyber attacks.

An IDS **does not stop attacks**. It only **detects**, **logs**, and **alerts** administrators.

## Primary Objectives

- Detect unauthorized access
- Identify attacks in real time
- Log malicious activities
- Generate alerts
- Assist in digital forensics

---

# 2. IDS vs IPS

|          IDS            |             IPS                 |
|        ------           |            -----                |
| Detects attacks         | Detects and blocks attacks      |
| Passive security        | Active security                 |
| Generates alerts        | Drops/rejects malicious packets |
| Does not modify traffic | Can block or modify traffic     |
| Used for monitoring     | Used for prevention             |

> **Exam Tip:** Every IPS performs IDS functions, but an IDS cannot prevent attacks.

---

# 3. Types of IDS

## A. Host-Based IDS (HIDS)

Installed on an individual host or server.

### Monitors

- System logs
- Running processes
- File integrity
- Registry (Windows)
- User activities

### Advantages

- Detects insider attacks
- Monitors decrypted traffic
- Detailed host visibility

### Disadvantages

- Protects only one machine
- Uses host resources
- Must be installed on every endpoint

### Examples

- OSSEC
- Wazuh
- Tripwire

---

## B. Network-Based IDS (NIDS)

Installed at strategic network locations to inspect packets flowing across the network.

### Monitors

- Network packets
- Protocols
- Sessions
- Traffic behavior

### Advantages

- Protects multiple hosts
- Centralized monitoring
- No endpoint installation

### Disadvantages

- Cannot inspect encrypted payloads
- High-speed traffic requires powerful hardware

### Examples

- Snort
- Suricata
- Zeek

---

# 4. Detection Techniques

## Signature-Based Detection

Matches traffic against known attack signatures.

Example

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
- Requires regular signature updates

---

## Anomaly-Based Detection

Builds a baseline of normal behavior and detects deviations.

Example

```text
Normal SSH Logins = 5/day

Today = 500

Alert Generated
```

### Advantages

- Detects zero-day attacks
- Finds unknown threats

### Disadvantages

- High false positives
- Requires learning period

---

## Behavior-Based Detection

Detects attacks by analyzing long-term behavior patterns rather than fixed signatures.

---

# 5. What is Snort?

**Snort** is a free and open-source **Network Intrusion Detection System (NIDS)** that can also function as an **Intrusion Prevention System (IPS)** in inline mode.

Originally developed by **Martin Roesch** in **1998** and currently maintained by **Cisco Talos**.

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

Captures packets from the network interface.

Responsibilities

- Receive packets
- Forward packets to Snort

---

## Packet Decoder

Decodes network protocols.

Supports

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

Functions

- TCP Stream Reassembly
- IP Fragment Reassembly
- Protocol Normalization
- HTTP Inspection
- Portscan Detection

---

## Detection Engine

The core of Snort.

Functions

- Compare packets with signatures
- Analyze protocol fields
- Inspect payload
- Generate alerts

---

## Output Modules

Responsible for

- Alerts
- Packet logging
- JSON output
- Syslog
- SIEM integration

---

# 8. Operational Modes

## 1. Sniffer Mode

Displays packets on screen.

Uses

- Troubleshooting
- Learning networking
- Packet inspection

---

## 2. Packet Logger Mode

Stores captured packets into files.

Uses

- Traffic analysis
- Incident investigation
- Packet replay

---

## 3. IDS Mode

Analyzes packets using rules.

If a rule matches

- Alert generated
- Event logged

Traffic is **NOT** blocked.

---

## 4. IPS (Inline) Mode

Traffic passes through Snort.

If malicious traffic matches

- Packet dropped
- Packet rejected
- Connection terminated

---

# 9. Snort Components

| Component | Function |
|-----------|----------|
| Packet Capture | Captures packets |
| Decoder | Decodes protocols |
| Preprocessors | Normalize traffic |
| Detection Engine | Detects attacks |
| Output Modules | Logs and alerts |

---

# 10. Snort Versions

## Snort 2.x

- Legacy version
- Stable
- Common in labs
- Uses `snort.conf`

---

## Snort 3.x

Current generation.

Improvements

- Multi-threading
- Better performance
- Better scalability
- Plugin architecture
- Lua configuration (`snort.lua`)

> **Note:** Snort 3.x is recommended for new deployments. Snort 2.x is still widely used for learning and legacy systems.

---

# 11. Snort Rule Sources

## Community Rules

- Free
- Community maintained

## Registered Rules

- Free after registration
- Maintained by Cisco Talos

## Subscriber Rules

- Paid
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
- Worms
- Command & Control (C2)

---

# 13. Advantages

- Free & Open Source
- Large community
- Frequently updated rules
- Highly customizable
- Lightweight
- Real-time detection
- IDS & IPS support
- SIEM integration

---

# 14. Limitations

- Mostly signature-based
- Requires rule updates
- Limited encrypted traffic inspection
- False positives if poorly tuned
- Requires powerful hardware for high-speed networks

---

# 15. Real-World Deployment

```text
Internet
    │
Firewall
    │
Switch
 ├── Servers
 ├── Clients
 └── Snort Sensor
          │
          ▼
     SIEM / SOC
```

Workflow

1. Traffic is mirrored to Snort.
2. Snort analyzes packets.
3. Malicious activity generates alerts.
4. Events are logged.
5. Alerts are forwarded to SIEM/SOC.
6. In IPS mode, malicious traffic is blocked.

---

# 16. Key Terms

| Term | Meaning |
|------|---------|
| IDS | Intrusion Detection System |
| IPS | Intrusion Prevention System |
| HIDS | Host-Based IDS |
| NIDS | Network-Based IDS |
| DPI | Deep Packet Inspection |
| Signature | Pattern of a known attack |
| Alert | Notification generated by Snort |
| Packet | Unit of network data |
| Preprocessor | Normalizes packets before inspection |
| Detection Engine | Matches traffic against signatures |
| SIEM | Security Information and Event Management |

---

# 17. Interview & Exam Quick Revision

- IDS detects and alerts.
- IPS detects and blocks.
- HIDS protects a host.
- NIDS protects a network.
- Snort is an open-source NIDS/IPS.
- Maintained by Cisco Talos.
- Snort architecture:
  - Packet Capture
  - Decoder
  - Preprocessors
  - Detection Engine
  - Output Modules
- Operational Modes:
  - Sniffer
  - Packet Logger
  - IDS
  - IPS (Inline)
- Snort 3.x is the current recommended version.
- Snort primarily uses signature-based detection.

---
**End of Chapter 1**
````
