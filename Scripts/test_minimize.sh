#!/bin/bash
# Test script to debug window minimizing

echo "=== All Windows ==="
wmctrl -l -G

echo ""
echo "=== Attempting to minimize each window ==="

while IFS= read -r line; do
    window_id=$(echo "$line" | awk '{print $1}')
    x_pos=$(echo "$line" | awk '{print $3}')
    title=$(echo "$line" | cut -d' ' -f9-)
    
    echo "Window: $window_id at X=$x_pos - $title"
    
    # Skip desktop/panel windows
    if [[ "$title" =~ (Plasma|Desktop|plasmashell) ]]; then
        echo "  -> Skipped (system window)"
        continue
    fi
    
    # Try to minimize
    echo "  -> Attempting to minimize..."
    if xdotool windowminimize "$window_id" 2>&1; then
        echo "  -> SUCCESS"
    else
        echo "  -> FAILED"
    fi
    echo ""
done < <(wmctrl -l -G)

echo "=== Done ==="
