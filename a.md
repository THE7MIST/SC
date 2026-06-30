# Nmap Port Scanning Commands

## Target Variable
```bash
<TARGET>
```

Example:
```bash
192.168.74.130
```

---

# 1. Fast Scan

## Command

```bash
nmap -F <TARGET>
```

Example

```bash
nmap -F 192.168.74.130
```

## What it does

Scans only the **100 most common TCP ports**.

## Why use it

- Very fast
- Quick reconnaissance
- Good first scan
- Identifies common services

---

# 2. Default Scan

## Command

```bash
nmap <TARGET>
```

Example

```bash
nmap 192.168.74.130
```

## What it does

Scans the **top 1000 TCP ports**.

## Why use it

- Default Nmap scan
- Finds most common services
- Balanced between speed and coverage

---

# 3. Scan a Specific Port

## Command

```bash
nmap -p <PORT> <TARGET>
```

Example

```bash
nmap -p 80 192.168.74.130
```

## What it does

Scans only one port.

## Why use it

Useful when checking:

- HTTP (80)
- HTTPS (443)
- SSH (22)
- FTP (21)

---

# 4. Scan Multiple Ports

## Command

```bash
nmap -p 22,80,443 <TARGET>
```

Example

```bash
nmap -p 21,22,80 192.168.74.130
```

## What it does

Scans only the specified ports.

## Why use it

Saves time when only interested in selected services.

---

# 5. Scan a Range of Ports

## Command

```bash
nmap -p 1-1024 <TARGET>
```

Example

```bash
nmap -p 20-100 192.168.74.130
```

## What it does

Scans every port within the range.

## Why use it

Useful when focusing on a section of ports.

---

# 6. Scan by Service Name

## Command

```bash
nmap -p http,https,ssh <TARGET>
```

Example

```bash
nmap -p http,ftp,ssh 192.168.74.130
```

## What it does

Scans ports associated with service names.

## Why use it

No need to remember port numbers.

---

# 7. Scan All TCP Ports

## Command

```bash
nmap -p- <TARGET>
```

or

```bash
nmap -p "*" <TARGET>
```

**Recommended syntax**

```bash
nmap -p- <TARGET>
```

Example

```bash
nmap -p- 192.168.74.130
```

## What it does

Scans all **65,535 TCP ports**.

## Why use it

- Finds uncommon services
- Finds backdoors
- Finds hidden applications
- Complete enumeration

---

# 8. Scan TCP and UDP Ports Together

## Command

```bash
nmap -sU -sT -p U:53,T:25 <TARGET>
```

Example

```bash
nmap -sU -sT -p U:53,T:25 192.168.74.130
```

## What it does

Performs

- UDP scan on port 53
- TCP scan on port 25

## Why use it

Some important services use UDP.

Examples

- DNS
- DHCP
- SNMP
- TFTP

---

# 9. UDP Scan

## Command

```bash
nmap -sU <TARGET>
```

Example

```bash
nmap -sU 192.168.74.130
```

## What it does

Scans UDP ports.

## Why use it

Many services only use UDP.

---

# 10. TCP Connect Scan

## Command

```bash
nmap -sT <TARGET>
```

Example

```bash
nmap -sT 192.168.74.130
```

## What it does

Uses the operating system's TCP connect() call.

## Why use it

Works without raw packet privileges.

---

# 11. Scan Top N Ports

## Command

```bash
nmap --top-ports <NUMBER> <TARGET>
```

Example

```bash
nmap --top-ports 10 192.168.74.130
```

## What it does

Scans only the specified number of most common ports.

## Why use it

Examples

Top 10

Top 20

Top 100

Top 500

Much faster than scanning all 1000.

---

# 12. Sequential Port Scan

## Command

```bash
nmap -r <TARGET>
```

Example

```bash
nmap -r 192.168.74.130
```

## What it does

Scans ports in ascending numerical order.

## Why use it

Normally Nmap randomizes ports.

Useful for

- Learning
- Demonstrations
- Predictable scanning

---

# 13. Verbose Sequential Scan

## Command

```bash
nmap -v -r <TARGET>
```

Example

```bash
nmap -v -r 192.168.74.130
```

## What it does

Shows discovered ports as the scan progresses.

## Why use it

Useful during

- Troubleshooting
- Watching scan progress
- Demonstrations

---

# 14. Verbose Mode

## Command

```bash
nmap -v <TARGET>
```

Example

```bash
nmap -v 192.168.74.130
```

## What it does

Displays additional information while scanning.

## Why use it

See scan progress in real time.

---

# 15. Skip Host Discovery (No Ping)

## Command

```bash
nmap -Pn <TARGET>
```

Example

```bash
nmap -Pn 192.168.74.130
```

## What it does

Treats the host as online and skips the initial ping check.

## Why use it

Useful when

- ICMP is blocked
- Firewalls drop ping requests
- Host appears down but is actually reachable

---

# Summary Table

| Command | Purpose |
|----------|----------|
| `nmap <TARGET>` | Scan top 1000 ports |
| `nmap -F <TARGET>` | Scan top 100 ports |
| `nmap -p 80 <TARGET>` | Scan one port |
| `nmap -p 22,80,443 <TARGET>` | Scan multiple ports |
| `nmap -p 1-1024 <TARGET>` | Scan range of ports |
| `nmap -p http,ssh <TARGET>` | Scan by service name |
| `nmap -p- <TARGET>` | Scan all 65535 ports |
| `nmap --top-ports 10 <TARGET>` | Scan top N ports |
| `nmap -sU <TARGET>` | UDP scan |
| `nmap -sT <TARGET>` | TCP Connect scan |
| `nmap -sU -sT -p U:53,T:25 <TARGET>` | Mixed UDP/TCP scan |
| `nmap -r <TARGET>` | Sequential scan |
| `nmap -v <TARGET>` | Verbose output |
| `nmap -v -r <TARGET>` | Verbose + Sequential |
| `nmap -Pn <TARGET>` | Skip host discovery |

---

# Notes

- `-F` = Fast scan (Top 100 ports)
- Default scan = Top 1000 ports
- `-p-` = All 65,535 TCP ports
- `--top-ports` = Scan the most common N ports
- `-r` = Sequential order
- `-v` = Verbose output
- `-Pn` = Skip ping (assume host is alive)
- `-sU` = UDP scan
- `-sT` = TCP Connect scan
- `-p` = Specify ports
