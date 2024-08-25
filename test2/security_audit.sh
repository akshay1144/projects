#!/bin/bash

# Security Audit and Server Hardening Script

################################################

# Written By Akshay On 24-08-2024  #


################################################

audit_users_groups() {
    echo "### User and Group Audits ###"
    echo "Listing all users and groups..."
    awk -F':' '{ print $1 }' /etc/passwd
    awk -F':' '{ print $1 }' /etc/group

    echo "Checking for users with UID 0 (root privileges)..."
    awk -F':' '($3 == 0) { print $1 }' /etc/passwd

    echo "Checking for users without passwords or with weak passwords..."
    awk -F':' '($2 == "" || $2 == "*") { print $1 }' /etc/shadow
}

audit_file_permissions() {
    echo "### File and Directory Permissions ###"
    echo "Scanning for world-writable files and directories..."
    find / -perm -0002 -type d -print

    echo "Checking .ssh directory permissions..."
    find /home -name ".ssh" -exec ls -ld {} \;

    echo "Reporting files with SUID/SGID bits set..."
    find / -perm /6000 -type f -exec ls -ld {} \;
}

audit_services() {
    echo "### Service Audits ###"
    echo "Listing all running services..."
    systemctl list-units --type=service --state=running

    echo "Checking critical services (sshd, iptables)..."
    systemctl is-active sshd iptables

    echo "Checking for services listening on non-standard or insecure ports..."
    ss -tuln
}

audit_firewall_network() {
    echo "### Firewall and Network Security ###"
    echo "Verifying firewall status and configuration..."
    ufw status verbose

    echo "Reporting open ports and associated services..."
    ss -tuln

    echo "Checking for IP forwarding..."
    sysctl net.ipv4.ip_forward
}

audit_ip_config() {
    echo "### IP and Network Configuration Checks ###"
    echo "Identifying public vs. private IP addresses..."
    ip -o -4 addr list | awk '{print $2, $4}'

    echo "Checking if sensitive services are exposed on public IPs..."
    ss -tuln | grep ':22'
}

audit_security_updates() {
    echo "### Security Updates and Patching ###"
    echo "Checking for available security updates..."
    apt-get update && apt-get upgrade --dry-run

    echo "Ensuring automatic updates are configured..."
    grep -r 'APT::Periodic::Unattended-Upgrade' /etc/apt/apt.conf.d/
}

audit_log_monitoring() {
    echo "### Log Monitoring ###"
    echo "Checking for suspicious log entries..."
    grep "Failed password" /var/log/auth.log | tail -n 10
}

hardening_steps() {
    echo "### Server Hardening Steps ###"
    echo "Configuring SSH..."
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    systemctl restart sshd

    echo "Disabling IPv6..."
    sysctl -w net.ipv6.conf.all.disable_ipv6=1
    sysctl -w net.ipv6.conf.default.disable_ipv6=1

    echo "Securing the bootloader..."
    echo "GRUB_CMDLINE_LINUX=\"\""
    update-grub

    echo "Configuring the firewall..."
    ufw default deny incoming
    ufw allow ssh
    ufw enable

    echo "Setting up automatic security updates..."
    apt-get install unattended-upgrades
    dpkg-reconfigure --priority=low unattended-upgrades
}

custom_security_checks() {
    echo "### Custom Security Checks ###"
    # Add custom checks here
}

generate_report() {
    echo "Generating security audit and hardening report..."
    {
        audit_users_groups
        audit_file_permissions
        audit_services
        audit_firewall_network
        audit_ip_config
        audit_security_updates
        audit_log_monitoring
        hardening_steps
    } > /var/log/security_audit_report.txt

    echo "Report saved to /var/log/security_audit_report.txt"
    # Send report via email (requires mailutils)
    # mail -s "Security Audit Report" admin@example.com < /var/log/security_audit_report.txt
}

generate_report
custom_security_checks
