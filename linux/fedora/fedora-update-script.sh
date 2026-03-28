#!/bin/bash

LOGFILE="fedora-update-script.log"

echo "Starting Fedora system update..." | tee -a $LOGFILE

# Refresh the package lists
echo "Refreshing package lists..." | tee -a $LOGFILE
if ! dnf check-update &>> $LOGFILE; then
    echo "Failed to refresh package lists" | tee -a $LOGFILE
    exit 1
fi

# Update all packages
echo "Updating all packages..." | tee -a $LOGFILE
if ! dnf -y update &>> $LOGFILE; then
    echo "Failed to update packages" | tee -a $LOGFILE
    exit 1
fi

# Upgrade the entire system
echo "Upgrading the entire system..." | tee -a $LOGFILE
if ! dnf -y upgrade --refresh &>> $LOGFILE; then
    echo "Failed to upgrade the system" | tee -a $LOGFILE
    exit 1
fi

# Clean up old packages
echo "Cleaning up old packages..." | tee -a $LOGFILE
if ! dnf -y autoremove &>> $LOGFILE; then
    echo "Failed to clean up old packages" | tee -a $LOGFILE
    exit 1
fi

# Clean DNF cache
echo "Cleaning DNF cache..." | tee -a $LOGFILE
if ! dnf clean all &>> $LOGFILE; then
    echo "Failed to clean DNF cache" | tee -a $LOGFILE
    exit 1
fi

echo "Fedora system update completed." | tee -a $LOGFILE
echo "It's recommended to restart your system to ensure all updates take effect."#!/bin/bash
