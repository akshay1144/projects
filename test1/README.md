# System Monitoring Bash Script

## Description
This bash script provides a real-time dashboard for monitoring various system resources. The dashboard refreshes every 10 seconds and can display specific system metrics individually through command-line switches.

## Features
1. **Top 10 Most Used Applications**: Displays the top 10 CPU and memory consuming applications.
2. **Network Monitoring**: Provides insights into concurrent connections, packet drops, and network traffic.
3. **Disk Usage**: Shows disk space usage and highlights partitions using more than 80% of their capacity.
4. **System Load**: Displays the current load average and a breakdown of CPU usage.
5. **Memory Usage**: Displays total, used, and free memory.
6. **Process Monitoring**: Shows the number of active processes and the top 5 consuming CPU and memory.
7. **Service Monitoring**: Monitors the status of essential services like `sshd`, `nginx/apache`, and `iptables`.
8. **Custom Dashboard**: Allows users to view specific parts of the dashboard using command-line switches.

## Usage
Run the script to see full dashboard


## Command to run

 ./system_monitor.sh
