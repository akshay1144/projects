#!/bin/bash

function user_group_audit {
  echo "User and Group Audits:"
  echo "Users with UID 0 (root):"
  awk -F: '$3 == 0 {print $1}' /etc/passwd
  echo "Group IDs:"
  awk -F: '{print $1 ": " $3}' /etc/group
}

function file_permissions {
  echo "File and Directory Permissions:"
  echo "SUID/SGID executables:"
  find / -perm /6000 -type f 2>/dev/null
}

function service_audit {
  echo "Service Audits:"
  for service in sshd nginx apache2; do
    echo "$service status: $(systemctl is-active $service)"
  done
}

function firewall_network_security {
  echo "Firewall and Network Security:"
  echo "Current iptables rules:"
  iptables -L -v -n
}

function ip_network_config {
  echo "IP and Network Configuration Checks:"
  echo "Network interfaces and IP addresses:"
  ip a
  echo "Routing table:"
  ip r
}

function security_updates {
  echo "Security Updates and Patching:"
  echo "Available updates:"
  apt list --upgradable 2>/dev/null
}

function log_monitoring {
  echo "Log Monitoring:"
  echo "Last 10 entries in auth.log:"
  tail -n 10 /var/log/auth.log
}

function server_hardening {
  echo "Server Hardening Steps:"
  echo "Checking for unnecessary services:"
  systemctl list-unit-files | grep enabled
}

function custom_security_checks {
  echo "Custom Security Checks:"
  # Add any custom security checks here
  echo "Custom checks are not defined."
}

function report_dashboard {
  clear
  echo "Security Audit and Hardening Dashboard - $(date)"
  echo "========================================"
  user_group_audit
  echo "========================================"
  file_permissions
  echo "========================================"
  service_audit
  echo "========================================"
  firewall_network_security
  echo "========================================"
  ip_network_config
  echo "========================================"
  security_updates
  echo "========================================"
  log_monitoring
  echo "========================================"
  server_hardening
  echo "========================================"
  custom_security_checks
  echo "========================================"
}

function refresh_dashboard {
  while true; do
    report_dashboard
    sleep 10
  done
}

while getopts ":u:f:s:f:i:p:l:h:c:r" opt; do
  case ${opt} in
    u ) user_group_audit
      ;;
    f ) file_permissions
      ;;
    s ) service_audit
      ;;
    f ) firewall_network_security
      ;;
    i ) ip_network_config
      ;;
    p ) security_updates
      ;;
    l ) log_monitoring
      ;;
    h ) server_hardening
      ;;
    c ) custom_security_checks
      ;;
    r ) refresh_dashboard
      ;;
    h ) echo "Usage: $0 [-u (user/group audit)] [-f (file permissions)] [-s (service audit)] [-f (firewall)] [-i (IP/network config)] [-p (security updates)] [-l (log monitoring)] [-h (server hardening)] [-c (custom checks)] [-r (dashboard)]"
      ;;
    \? ) echo "Invalid option: -$OPTARG" 1>&2
      ;;
  esac
done

if [ $# -eq 0 ]; then
  refresh_dashboard
fi
