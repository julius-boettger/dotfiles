#!/bin/sh
# takes about 1 second to run

# cpu usage percent as integer from 0 to 100
actual=$(vmstat 1 2 | tail -1 | awk '{print $15}' | { read idle; echo $((100 - $idle)); })
# logarithmic value with base 10 (still integer from 0 to 100)
offset=1 # add to actual and max (100) so result is never 0
echo $(python -c "import math; print(round(math.log10((($actual+$offset)/((100+$offset)/9)+1))*100))")