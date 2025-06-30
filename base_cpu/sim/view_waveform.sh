#!/bin/bash
# Usage: bash sim/view_waveform.sh <vcd_file>
# Example: bash sim/view_waveform.sh sim/pc.vcd

if [ $# -eq 0 ]; then
    echo "Usage: bash sim/view_waveform.sh <vcd_file>"
    echo "Available VCD files:"
    ls -1 sim/*.vcd 2>/dev/null || echo "No VCD files found in sim/ directory"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "Error: File '$1' not found"
    exit 1
fi

echo "Opening $1 with Surfer..."
surfer "$1" 
