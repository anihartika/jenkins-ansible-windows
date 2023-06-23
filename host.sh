#!/bin/bash

ansible-inventory --list|grep -o '"public_ip_address": "[^"]*'|awk -F': "' '{print $2}' > hosts.txt
hosts_file="hosts.txt"
inventory_file="inventory.ini"

# Check if the hosts file exists
if [ -f "$hosts_file" ]; then
    # Create an inventory file
    echo "[win]" > "$inventory_file"

    # Read the hosts from the file and append them to the inventory file
    while IFS= read -r host
    do
        echo "$host" >> "$inventory_file"
    done < "$hosts_file"

    echo "Inventory file generated: $inventory_file"
else
    echo "Hosts file not found: $hosts_file"
fi
