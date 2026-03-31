#!/usr/bin/env python3
"""
==================================================
T1-M1-S07 Lab: The Sentry (Python Foundations)
==================================================
Session 07: The Sentry (Python Foundations)
Environment: Chromebook Linux (Penguin)
The Goal: Master Python data types, variable casting,
and environment isolation to build stable security tools.

Mission: The Automation Forge
- Build a tool to "knock" on the digital doors (Ports)
  of five different servers to verify if SSH (Port 22) is responsive.

Description:
This script interrogates 5 servers to verify whether:
- SSH (Port 22) is responsive
- Each target is checked using a socket connection with a 1-second timeout

==================================================
Port Check
==================================================
"""
import socket

# A list of our server IPs
targets = ["127.0.0.1", "8.8.8.8", "1.1.1.1", "10.0.0.1", "100.115.92.193"]

for ip in targets:
    print(f"--- Checking Server: {ip} ---")
    
    # Create a socket to knock on the door
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    
    # Set a timer so we don't wait forever
    s.settimeout(1)
    
    # Knock on Port 22 (SSH)
    result = s.connect_ex((ip, 22))
    
    # 0 means Open, anything else means Closed
    if result == 0:
        print(f"SUCCESS: Port 22 is OPEN on {ip}")
    else:
        print(f"FAILED: Port 22 is CLOSED on {ip}")
    
    # Close the connection
    s.close()
