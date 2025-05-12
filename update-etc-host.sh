#!/bin/bash

# Script to update /etc/hosts with IPs of multiple hostnames from a configuration file, handling CNAMEs

CONFIG_FILE="/etc/hosts_list.txt"
HOSTS_FILE="/etc/hosts"
TEMP_FILE="/tmp/hosts_temp"
DNS_SERVER="8.8.8.8"
LOG_FILE="/var/log/update_etc_host.log"

# Function to validate if a string is a valid IP
is_valid_ip() {
    local ip=$1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to resolve a hostname to an IP, handling CNAMEs
resolve_to_ip() {
    local hostname=$1
    local result
    local ip

    # Try to resolve to an IP
    result=$(dig @${DNS_SERVER} ${hostname} +short)
    for entry in $result; do
        if is_valid_ip "$entry"; then
            echo "$entry"
            return 0
        fi
    done

    # If no IP was found, try resolving the last CNAME
    last_cname=$(dig @${DNS_SERVER} ${hostname} +short | tail -n 1)
    if [ -n "$last_cname" ] && [ "$last_cname" != "$hostname" ]; then
        ip=$(dig @${DNS_SERVER} ${last_cname} +short | head -n 1)
        if is_valid_ip "$ip"; then
            echo "$ip"
            return 0
        fi
    fi

    echo ""
    return 1
}

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "$(date): Error: Configuration file $CONFIG_FILE does not exist" >> "$LOG_FILE"
    exit 1
fi

# Create a copy of /etc/hosts without entries for hostnames in CONFIG_FILE
grep -v -f "$CONFIG_FILE" "$HOSTS_FILE" > "$TEMP_FILE" 2>> "$LOG_FILE"

# Read each hostname from the configuration file
while IFS= read -r HOSTNAME; do
    # Skip empty lines or comments
    if [[ -z "$HOSTNAME" || "$HOSTNAME" == \#* ]]; then
        continue
    fi

    # Get the current IP using the resolve_to_ip function
    IP=$(resolve_to_ip "$HOSTNAME")

    # Check if a valid IP was obtained
    if [ -z "$IP" ]; then
        echo "$(date): Error: Could not resolve IP for $HOSTNAME using $DNS_SERVER" >> "$LOG_FILE"
        continue
    fi

    # Check if the IP has changed
    CURRENT_IP=$(grep "$HOSTNAME" "$HOSTS_FILE" | awk '{print $1}')
    if [ "$IP" == "$CURRENT_IP" ]; then
        echo "$(date): IP for $HOSTNAME ($IP) has not changed" >> "$LOG_FILE"
        continue
    fi

    # Add the new entry to the temporary file
    echo "$IP $HOSTNAME" >> "$TEMP_FILE"
    echo "$(date): Updated $HOSTNAME to $IP" >> "$LOG_FILE"

done < "$CONFIG_FILE"

# Replace /etc/hosts with the temporary file
mv "$TEMP_FILE" "$HOSTS_FILE" 2>> "$LOG_FILE"
if [ $? -eq 0 ]; then
    echo "$(date): $HOSTS_FILE updated successfully" >> "$LOG_FILE"
else
    echo "$(date): Error updating $HOSTS_FILE" >> "$LOG_FILE"
    exit 1
fi

exit 0
