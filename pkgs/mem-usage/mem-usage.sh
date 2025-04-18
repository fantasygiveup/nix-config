#!/usr/bin/env bash

# Calculate memory usage in gigabytes in the format of: '39% of 30.5GB'.

awk '/MemTotal/{total=$2/1024/1024} /MemFree/{free=$2/1024/1024} END{printf "%02.f%% of %.1fGB\n", 100-((free/total)*100), total}' /proc/meminfo
