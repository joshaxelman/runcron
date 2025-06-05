#!/bin/bash

# Colors
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
BLUE=$(tput setaf 4)
GREEN=$(tput setaf 2)
GRAY=$(tput setaf 8)
BG=$(tput setab 0)
RESET=$(tput sgr0)

# Fetch crontab
cronjobs=$(crontab -l 2>/dev/null | grep -vE '^\s*#|^\s*$')
if [ -z "$cronjobs" ]; then
  echo "${BOLD}${BLUE}No cron jobs found for user: $USER${NORMAL}"
  exit 0
fi

IFS=$'\n' read -rd '' -a job_array <<<"$cronjobs"

echo
echo "${BOLD}${GREEN}🕒 Your Cron Jobs${NORMAL}"
echo "─────────────────────────────"

# Print each job with spacing
for i in "${!job_array[@]}"; do
  num=$((i+1))
  printf "\n${BOLD}${BLUE}[%d]${NORMAL}\n" "$num"
  echo -e "  ${GRAY}${job_array[$i]}${NORMAL}"
done

echo
echo -n "${BOLD}Select a job to run [1-${#job_array[@]}]: ${NORMAL}"
read -r selection

# Validate input
if [[ ! $selection =~ ^[0-9]+$ ]] || (( selection < 1 || selection > ${#job_array[@]} )); then
  echo "${BOLD}❌ Invalid selection.${NORMAL}"
  exit 1
fi

# Extract command
selected="${job_array[$((selection-1))]}"
cmd=$(echo "$selected" | sed -E 's/^(@[a-z]+|\S+\s+\S+\s+\S+\s+\S+\s+\S+)\s+//')

echo
echo "${BOLD}${GREEN}▶️ Running:${NORMAL} $cmd"
echo "─────────────────────────────"
echo

# Run it
bash -c "$cmd"
