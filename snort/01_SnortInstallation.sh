
#!/usr/bin/env bash

set -e

echo "======================================="
echo "      Snort 2 Installation Script"
echo "======================================="

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
    echo "[!] Please run this script with sudo."
    exit 1
fi

# User Input
read -rp "Enter network interface (e.g. ens33): " interface
read -rp "Enter HOME_NET (e.g. 192.168.74.0/24): " homeNetwork

echo
echo "[1/8] Updating package repository..."
apt update

echo
echo "[2/8] Installing Snort..."
apt install -y snort

echo
echo "[3/8] Refreshing shared library cache..."
ldconfig

echo
echo "[4/8] Verifying Snort installation..."
snort -V

echo
echo "[5/8] Checking Snort user..."
if id snort &>/dev/null; then
    echo "[OK] Snort user exists."
    id snort
else
    echo "[WARNING] Snort user not found."
fi

echo
echo "[6/8] Creating backup of snort.conf..."
cp -av /etc/snort/snort.conf "/etc/snort/snort.conf_orig_$(date +%F_%H-%M-%S)"

echo
echo "[7/8] Updating snort.conf..."

# Comment default HOME_NET
sed -i 's/^ipvar HOME_NET any/#ipvar HOME_NET any/' /etc/snort/snort.conf

# Remove existing custom HOME_NET (if any)
sed -i '/^ipvar HOME_NET [0-9].*/d' /etc/snort/snort.conf

# Insert new HOME_NET
sed -i "/^#ipvar HOME_NET any/a ipvar HOME_NET ${homeNetwork}" /etc/snort/snort.conf

# Uncomment local.rules
sed -i 's/^#include \$RULE_PATH\/local.rules/include \$RULE_PATH\/local.rules/' /etc/snort/snort.conf

# Comment every other rule include
sed -i '/^include \$RULE_PATH\/.*\.rules$/{
    /local\.rules/! s/^/#/
}' /etc/snort/snort.conf

echo
echo "[8/8] Validating Snort configuration..."

snort -T \
-i "$interface" \
-c /etc/snort/snort.conf

echo
echo "======================================="
echo "       Installation Completed"
echo "======================================="

echo
echo "Configuration Summary"
echo "----------------------"
echo "Interface : $interface"
echo "HOME_NET  : $homeNetwork"
echo "Config    : /etc/snort/snort.conf"
echo "Rules     : /etc/snort/rules/local.rules"

echo
echo "Next Steps"
echo "----------"
echo "1. Edit local.rules"
echo "2. Add your custom Snort rules"
echo "3. Test using:"
echo
echo "sudo snort -T -i $interface -c /etc/snort/snort.conf"
echo
echo "4. Run Snort:"
echo
echo "sudo snort -A console -q -i $interface -c /etc/snort/snort.conf"
