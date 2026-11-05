#!/bin/sh
# Status-line segment: CPU bar + percentage, and memory percentage.
#
# tmux-mem-cpu-load is run ONCE and its raw output reformatted here, so the
# segment can carry tmux style escapes that the tool itself cannot emit in
# this palette. Called from status-right in ~/.tmux.conf.
#
#   --mem-mode 2       memory as a percentage
#   --graph-lines 0    suppress the built-in bar; drawn below instead
#   --averages-count 0 no load averages
#   --interval 2       CPU sampling window; matches status-interval
#
# Raw output looks like: "65.38%  13.6%"

# Kanso Zen palette, kept in sync with ~/.tmux.conf
zen_dim='#727169'    # fujiGray   - labels and brackets
zen_low='#7FB4CA'    # crystalBlue - under 60%
zen_mid='#E6C384'    # carpYellow  - 60-80%
zen_high='#E46876'   # samuraiRed  - over 80%

tmux-mem-cpu-load --interval 2 --mem-mode 2 --graph-lines 0 --averages-count 0 |
awk -v dim="$zen_dim" -v low="$zen_low" -v mid="$zen_mid" -v high="$zen_high" '
function tone(v) { return v >= 80 ? high : (v >= 60 ? mid : low) }
{
    cpu = $2 + 0
    mem = $1 + 0

    slots  = 8
    filled = int(cpu / 100 * slots + 0.5)
    bar    = ""
    for (i = 0; i < slots; i++) bar = bar (i < filled ? "█" : "░")

    printf "#[fg=%s][cpu #[fg=%s]%s %4.1f%%#[fg=%s]] [mem #[fg=%s]%3.0f%%#[fg=%s]]",
           dim, tone(cpu), bar, cpu, dim, tone(mem), mem, dim
}'
