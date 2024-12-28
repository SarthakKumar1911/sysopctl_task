#!/bin/bash

# Help Option
if [[ "$1" == "--help" ]]; then
    echo "sysopctl v0.1.0"
    echo "Usage: sysopctl [command] [options]"
    echo ""
    echo "Options:"
    echo "  --help          Show this help message."
    echo "  --version       Display version information."
    exit 0
fi

# Version Option
if [[ "$1" == "--version" ]]; then
    echo "sysopctl v0.1.0"
    exit 0
fi

# List Running Services
if [[ "$1" == "service" && "$2" == "list" ]]; then
    systemctl list-units --type=service --state=running
    exit 0
fi

# Display System Load
if [[ "$1" == "system" && "$2" == "load" ]]; then
    uptime
    exit 0
fi

# Start a Service
if [[ "$1" == "service" && "$2" == "start" ]]; then
    if [[ -z "$3" ]]; then
        echo "Error: Service name not provided."
        echo "Usage: sysopctl service start <service-name>"
        exit 1
    fi
    systemctl start "$3"
    echo "Service '$3' started successfully."
    exit 0
fi

# Stop a Service
if [[ "$1" == "service" && "$2" == "stop" ]]; then
    if [[ -z "$3" ]]; then
        echo "Error: Service name not provided."
        echo "Usage: sysopctl service stop <service-name>"
        exit 1
    fi
    systemctl stop "$3"
    echo "Service '$3' stopped successfully."
    exit 0
fi

# Check Disk Usage
if [[ "$1" == "disk" && "$2" == "usage" ]]; then
    df -h
    exit 0
fi

# Monitor Processes
if [[ "$1" == "process" && "$2" == "monitor" ]]; then
    echo "Opening process monitor..."
    htop
    exit 0
fi

# Analyze Logs
if [[ "$1" == "logs" && "$2" == "analyze" ]]; then
    echo "Fetching system logs..."
    journalctl -xe
    exit 0
fi

# Backup Files or Directories
if [[ "$1" == "backup" ]]; then
    if [[ -z "$2" ]]; then
        echo "Error: Source path not provided."
        echo "Usage: sysopctl backup <source-path> [destination-path]"
        exit 1
    fi

    # Default backup location if none is specified
    BACKUP_DESTINATION=${3:-/tmp/sysopctl_backup}

    # Create the destination directory if it doesn't exist
    mkdir -p "$BACKUP_DESTINATION"

    # Perform the backup using rsync
    rsync -avh "$2" "$BACKUP_DESTINATION"

    if [[ $? -eq 0 ]]; then
        echo "Backup of '$2' completed successfully to '$BACKUP_DESTINATION'."
    else
        echo "Error: Backup failed. Please check the source path and permissions."
    fi
    exit 0
fi
