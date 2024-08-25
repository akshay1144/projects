#!/bin/bash

# Function to display the top 10 most CPU/memory consuming applications
function top_apps {
  echo "Top 10 CPU/Memory Consuming Applications:"
  ps aux --sort=-%cpu,-%mem | head -n 11
}

# Function to monitor network statistics
function network_monitor {
  echo "Network Monitoring:"
  echo "Concurrent Connections: $(netstat -an | grep ESTABLISHED | wc -l)"
  echo "Packet Drops: $(netstat -i | grep -v 'Iface' | awk '{print $1 " " $4 " " $5}')"
  echo "Network Traffic (MB):"
  ifstat -i eth0 1 1 | awk '/eth0/ {print "In: " $6, "Out: " $8}'
}

# Function to display disk usage
function disk_usage {
  echo "Disk Usage:"
  df -h | awk '$5 > 80 {print "Warning: " $1 " is " $5 " full."}'
  df -h
}

# Function to display system load
function system_load {
  echo "System Load and CPU Breakdown:"
  uptime
  echo "CPU Usage Breakdown:"
  mpstat | awk '/all/ {print "User: " $3 "%, System: " $5 "%, Idle: " $12 "%"}'
}

# Function to display memory usage
function memory_usage {
  echo "Memory Usage:"
  free -h
}

# Function to monitor processes
function process_monitor {
  echo "Process Monitoring:"
  echo "Active Processes: $(ps aux | wc -l)"
  echo "Top 5 CPU/Memory Consuming Processes:"
  ps aux --sort=-%cpu,-%mem | head -n 6
}

# Function to monitor essential services
function service_monitor {
  echo "Service Monitoring:"
  for service in sshd nginx apache2 iptables; do
    systemctl is-active --quiet $service && echo "$service is running" || echo "$service is not running"
  done
}

# Function to refresh every 10 seconds
function refresh_dashboard {
  while true; do
    clear
    echo "System Dashboard - $(date)"
    echo "========================================"
    top_apps
    echo "========================================"
    network_monitor
    echo "========================================"
    disk_usage
    echo "========================================"
    system_load
    echo "========================================"
    memory_usage
    echo "========================================"
    process_monitor
    echo "========================================"
    service_monitor
    sleep 10
  done
}

# Command-line switches
while getopts ":a:n:d:l:m:p:s:h" opt; do
  case ${opt} in
    a ) top_apps
      ;;
    n ) network_monitor
      ;;
    d ) disk_usage
      ;;
    l ) system_load
      ;;
    m ) memory_usage
      ;;
    p ) process_monitor
      ;;
    s ) service_monitor
      ;;
    h ) echo "Usage: $0 [-a (apps)] [-n (network)] [-d (disk)] [-l (load)] [-m (memory)] [-p (process)] [-s (services)]"
      ;;
    \? ) echo "Invalid option: -$OPTARG" 1>&2
      ;;
  esac
done

# If no option is provided, show the dashboard
if [ $# -eq 0 ]; then
  refresh_dashboard
fi
