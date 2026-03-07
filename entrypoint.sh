#!/bin/bash
set -e

CONFIG_FILE="/app/client_config"

# 1. Check if configuration file exists, generate default if missing
if [ ! -f "$CONFIG_FILE" ]; then
    echo "[Init] Configuration file not found. Generating default settings at $CONFIG_FILE ..."
    
    cat << 'EOF' > "$CONFIG_FILE"

oci=begin

[DEFAULT]
user=ocid1.user.oc1..aaaaaaaaxxxxgwlg3xuzwgsaazxtzbozqq
fingerprint=b8:33:6f:xxxx:45:43:33
tenancy=ocid1.tenancy.oc1..aaaaaaaaxxx7x7h4ya
region=ap-singapore-1
key_file=/app/your_api_key.pem

oci=end

username=
password=

model=local
EOF
    echo "[Init] Default configuration generated. Please update the client_config file in your host mount directory and restart the container."

# 2. If file exists, check for path compatibility
else
    echo "[Init] Existing profile detected. Running mount path compatibility check..."
    
    if grep -q "key_file=/root/" "$CONFIG_FILE"; then
        echo "[Warning] Detected legacy host path: key_file=/root/..."
        echo "[Fixup] Automatically correcting to Docker internal mount path (key_file=/app/)..."
        
        sed -i 's|key_file=/root/|key_file=/app/|g' "$CONFIG_FILE"
        
        echo "[Fixup] Path correction complete!"
    else
        echo "[Init] Configuration path check passed."
    fi
fi

# 3. Transfer control to the main application
exec "$@"