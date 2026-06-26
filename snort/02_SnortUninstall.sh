```bash
#!/usr/bin/env bash

echo "========================================"
echo "      Snort Complete Removal Script"
echo "========================================"

# Stop service (ignore errors if not installed)
sudo systemctl stop snort 2>/dev/null
sudo systemctl disable snort 2>/dev/null

# Remove package
sudo apt purge --autoremove -y snort

# Remove configuration
sudo rm -rf /etc/snort

# Remove logs
sudo rm -rf /var/log/snort

# Remove cache
sudo apt autoclean
sudo apt clean

# Refresh library cache
sudo ldconfig

echo
echo "Remaining Snort files (if any):"
find / -iname "*snort*" 2>/dev/null

echo
echo "Verify Installation:"
snort -V 2>/dev/null || echo "✓ Snort successfully removed."

echo
echo "========================================"
echo "         Removal Complete"
echo "========================================"
```
