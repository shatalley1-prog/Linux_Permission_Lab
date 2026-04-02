#!/usr/bin/env python3
"""
==================================================
T1-M1-S08 Lab
==================================================
Session 08: The Paper Trail (Logic, Loops, & Lists)
Environment: Chromebook Linux (Penguin)

The Goal: Architect autonomous decision-making logic and utilize loops to process security data at scale.
Mission: Build a tool that scans through a messy system log to find and extract the footprints of a hacker.

Description: This script filters Failed password attempts into a clean report.
==================================================
Brute Detector
==================================================
"""
attack_count = 0

with open("auth_audit.log", "r") as log_file:
    with open("brute_report.txt", "w") as report_file:
        for line in log_file:
            if "Failed password" in line:
                report_file.write(line)
                attack_count = attack_count + 1

print(f"[*] Audit Complete. Extracted {attack_count} threat signatures to brute_report.txt")
