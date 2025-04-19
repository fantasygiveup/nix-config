#!/usr/bin/env bash

set -euo pipefail

printf "%02.f" "$(dunstctl count history)"
