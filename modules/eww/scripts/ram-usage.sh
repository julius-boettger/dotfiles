#!/bin/sh
# calculation inspired by https://github.com/lcpz/lain/blob/0a2ff9e1dea4093088c30af0b75ccd94a4f700ad/widget/mem.lua

nums=$(cat /proc/meminfo \
    | grep -e MemTotal -e MemFree -e Buffers -e Cached -e SReclaimable \
    | awk '{print $2}')

# in MB
  total=$(echo $nums | awk '{print $1}' | { read kb; echo $((kb / 1000)); })
   free=$(echo $nums | awk '{print $2}' | { read kb; echo $((kb / 1000)); })
buffers=$(echo $nums | awk '{print $3}' | { read kb; echo $((kb / 1000)); })
 cached=$(echo $nums | awk '{print $4}' | { read kb; echo $((kb / 1000)); })
   srec=$(echo $nums | awk '{print $5}' | { read kb; echo $((kb / 1000)); })

used=$(($total - $free - $buffers - $cached - $srec))

# percent value between 0 and 100, logarithmic scale with base 10
offset=250 # subtract from used and total as both values never go below this
used_percent=$(python -c "import math; print(round(math.log10((($used-$offset)/(($total-$offset)/9)+1))*100))")

echo "{\"total\":$total,\"used\":$used,\"used_percent\":$used_percent}"