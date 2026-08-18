#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
EFFORT=$(echo "$input" | jq -r '.effort.level // empty')
FIVE_HR=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')

CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; RESET='\033[0m'

# Pick bar color based on context usage
if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

FILLED=$((PCT / 10)); EMPTY=$((10 - FILLED))
printf -v FILL "%${FILLED}s"; printf -v PAD "%${EMPTY}s"
BAR="${FILL// /█}${PAD// /░}"

BRANCH=""
git -C "$DIR" rev-parse --git-dir > /dev/null 2>&1 && BRANCH=" | 🌿 $(git -C "$DIR" branch --show-current 2>/dev/null)"

# Build right-side annotation
EXTRA=""
[ -n "$EFFORT" ] && EXTRA=" | effort:${EFFORT}"
[ -n "$FIVE_HR" ] && EXTRA="${EXTRA} | 5h:$(printf '%.0f' "$FIVE_HR")%"

echo -e "${CYAN}[$MODEL]${RESET} 📁 ${DIR##*/}$BRANCH"
echo -e "${BAR_COLOR}${BAR}${RESET} ${PCT}%${EXTRA}"
