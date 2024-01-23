#!/bin/bash

# Print installation instructions
echo "Usually to install database software, we will use ./runInstaller graphical user interface."
echo "Sometimes we may not have access to a graphical user interface."
echo "Silent mode installation allows configuring necessary Oracle components without using the graphical interface."
echo "In this response file can be used to provide all the required information for the installation, so no additional user input is required."

# Function to check physical RAM
check_physical_ram() {
    echo "Checking Physical RAM..."
    total_ram=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    if [ "$total_ram" -ge 8192000 ]; then
        echo "Physical RAM check passed."
    else
        echo "Error: Insufficient Physical RAM. Minimum requirement is 8192 MB."
    fi
}

# Function to check swap space
check_swap_space() {
    echo "Checking Swap Space..."
    total_swap=$(grep SwapTotal /proc/meminfo | awk '{print $2}')
    if [ "$total_swap" -ge 8192000 ]; then
        echo "Swap Space check passed."
    else
        echo "Error: Insufficient Swap Space. Minimum requirement is 8192 MB."
    fi
}

# Function to check space available in /tmp directory
check_tmp_space() {
    echo "Checking space in /tmp directory..."
    tmp_space=$(df -h /tmp | awk 'NR==2 {print $4}')
    if [ "${tmp_space%?}" -ge 2048 ]; then
        echo "Space in /tmp directory check passed."
    else
        echo "Error: Insufficient space in /tmp directory. Minimum requirement is 2048 MB."
    fi
}

# Function to check Oracle Software space
check_oracle_space() {
    echo "Checking space for Oracle Software..."
    oracle_space=$(du -sh /path/to/oracle/software/directory | awk '{print $1}')
    echo "Space requirement for Oracle 19c Software: Enterprise Edition 10G (Minimum)"
    echo "Space available: $oracle_space"
}

# Function to check system architecture
check_system_architecture() {
    echo "Checking system architecture..."
    model_name=$(grep "model name" /proc/cpuinfo | awk -F: '{print $2}' | tr -s ' ' | head -n 1)
    echo "Processor type: $model_name"
    # Add logic to verify the processor architecture against Oracle software release
    # Note: Additional logic needs to be added based on your specific requirements.
}

# Function to verify OS version
check_os_version() {
    echo "Verifying OS version..."
    os_version=$(cat /etc/redhat-release)
    echo "OS Version: $os_version"
    # Add logic to verify the OS version based on your specific requirements.
}

# Install oracle-database-preinstall-19c package
install_prerequisites() {
    echo "Installing oracle-database-preinstall-19c package..."
    yum install -y oracle-database-preinstall-19c
    echo "oracle-database-preinstall-19c package installed successfully."
}

# Print download instructions for Oracle 19c db software
download_oracle_19c() {
    echo "Download the Oracle software from OTN or MY ORACLE SUPPORT (MOS):"
    echo "https://www.oracle.com/database/technologies/oracle19c-linux-downloads.html"
}

unzip_oracle_software() {
    echo "Checking contents of the directory before unzipping..."
    ls -lrt

    echo "Unzipping Oracle 19c db software in ORACLE HOME location..."
    oracle_home="/u01/app/oracle/product/19.0.0/db_1"
    unzip LINUX.X64_193000_db_home.zip -d $oracle_home

    echo "Checking contents of the directory after unzipping..."
    ls -lrt $oracle_home | grep -i LINUX.X64_193000_db_home.zip
    echo "Oracle 19c db software successfully unzipped in $oracle_home"
}

backup_response_file() {
    # Set environment variables
    ORACLE_HOME="/u01/app/oracle/product/19.0.0/db_1"

    # Define file paths
    DB_INSTALL_RSP="$ORACLE_HOME/install/response/db_install.rsp"
    DBCA_RSP_DIR="$ORACLE_HOME/assistants/dbca"
    NETCA_RSP_DIR="$ORACLE_HOME/assistants/netca"

    # List files
    echo "Listing files in $DB_INSTALL_RSP:"
    ls -ltr $DB_INSTALL_RSP

    echo "Listing files in $DBCA_RSP_DIR:"
    ls -ltr $DBCA_RSP_DIR/*.rsp

    echo "Listing files in $NETCA_RSP_DIR:"
    ls -ltr $NETCA_RSP_DIR/*.rsp

    # Check if db_install.rsp exists before taking a backup
    if [ -f "$DB_INSTALL_RSP" ]; then
        # Backup db_install.rsp
        echo "Creating a backup of db_install.rsp"
        cp "$DB_INSTALL_RSP" "$DB_INSTALL_RSP.bkp"
        # Display the updated list after backup
        echo "Listing files in $ORACLE_HOME/install/response after backup:"
        ls -ltr "$DB_INSTALL_RSP"*
    else
        echo "Warning: $DB_INSTALL_RSP does not exist. No backup created."
    fi
}

# Set environment variables
ORACLE_HOME="/u01/app/oracle/product/19.0.0/db_1"
# Define file paths
RESPONSE_FILE="$ORACLE_HOME/install/response/db_install.rsp"
# Function to modify parameters in the response file
modify_response_file() {
    sed -i \
        -e "s|^oracle.install.option=.*$|oracle.install.option=INSTALL_DB_AND_CONFIG|" \
        -e "s|^UNIX_GROUP_NAME=.*$|UNIX_GROUP_NAME=new_unix_group|" \
        -e "s|^INVENTORY_LOCATION=.*$|INVENTORY_LOCATION=/new/inventory/location|" \
        -e "s|^ORACLE_HOME=.*$|ORACLE_HOME=/new/oracle/home|" \
        -e "s|^ORACLE_BASE=.*$|ORACLE_BASE=/u01/app/oracle|" \
        -e "s|^oracle.install.db.InstallEdition=.*$|oracle.install.db.InstallEdition=EE|" \
        -e "s|^oracle.install.db.OSDBA_GROUP=.*$|oracle.install.db.OSDBA_GROUP=new_osdba_group|" \
        -e "s|^oracle.install.db.OSOPER_GROUP=.*$|oracle.install.db.OSOPER_GROUP=new_osoper_group|" \
        -e "s|^oracle.install.db.OSBACKUPDBA_GROUP=.*$|oracle.install.db.OSBACKUPDBA_GROUP=new_osbackupdba_group|" \
        -e "s|^oracle.install.db.OSDGDBA_GROUP=.*$|oracle.install.db.OSDGDBA_GROUP=new_osdgdba_group|" \
        -e "s|^oracle.install.db.OSKMDBA_GROUP=.*$|oracle.install.db.OSKMDBA_GROUP=new_oskmdba_group|" \
        -e "s|^oracle.install.db.OSRACDBA_GROUP=.*$|oracle.install.db.OSRACDBA_GROUP=new_osracdba_group|" \
        -e "s|^oracle.install.db.rootconfig.executeRootScript=.*$|oracle.install.db.rootconfig.executeRootScript=false|" \
        $RESPONSE_FILE
}

# Function to display the modified response file
show_modified_response_file() {
    echo "Modified Response File:"
    cat $RESPONSE_FILE
}

INSTALLER="$ORACLE_HOME/runInstaller"

# Function to execute Oracle Database Setup Wizard with prereqs and response file
execute_db_setup_wizard() {
    echo "Launching Oracle Database Setup Wizard..."
    $INSTALLER -executePrereqs -silent -responseFile $RESPONSE_FILE

    if [ $? -eq 0 ]; then
        echo "Prerequisite checks executed successfully."
    else
        echo "Prerequisite checks failed. Please check logs for details."
    fi
}

# Function to execute root.sh
execute_root_sh() {
    # Execute root.sh with sudo
    sudo $ORACLE_HOME/root.sh

    # Verify
    export ORACLE_HOME=$ORACLE_HOME
    export PATH=$ORACLE_HOME/bin:$PATH

    sqlplus -v > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "SQL*Plus installed successfully."
        
        # Log in with root user
        sqlplus / as sysdba
    else
        echo "Error: SQL*Plus installation failed."
    fi
}

# Main script execution
check_physical_ram
check_swap_space
check_tmp_space
check_oracle_space
check_system_architecture
check_os_version
install_prerequisites
download_oracle_19c
unzip_oracle_software
backup_response_file
modify_response_file
show_modified_response_file
execute_db_setup_wizard
execute_root_sh
