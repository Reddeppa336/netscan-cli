#!/bin/bash

LOGFILE="netscan.log"

show_help() {
    echo "Usage: $0 --target <IP> --ports <p1,p2,...>"
}

log() {
    echo "[$(date)] $1" >> "$LOGFILE"
}

parse_ports() {
    IFS=',' read -ra PORTS <<< "$1"
}

scan_port() {
    timeout 1 bash -c "echo > /dev/tcp/$TARGET/$1" 2>/dev/null
    return $?
}

# Argument Parsing
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --target) TARGET="$2"; shift ;;
        --ports) PORT_LIST="$2"; shift ;;
        --help) show_help; exit 0 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
    shift
done

# Validate input
if [ -z "$TARGET" ] || [ -z "$PORT_LIST" ]; then
    show_help
    exit 1
fi

parse_ports "$PORT_LIST"

log "Starting scan on $TARGET"

for port in "${PORTS[@]}"; do
    scan_port $port
    if [ $? -eq 0 ]; then
        echo "[OPEN] Port $port"
        log "Port $port OPEN"
    else
        echo "[CLOSED] Port $port"
    fi
done

log "Scan finished"