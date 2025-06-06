# runcron
A simple program with a CLI to list and run cronjobs

---

## 📦 Install

Paste this into your terminal:

```sh
curl -fsSL https://joshaxelman.github.io/runcron/scripts/install.sh | bash
```

## 🔗 Or Download Manually

[Download runcron.sh](./scripts/runcron.sh)

---

## 📝 Usage

Need to run a cronjob but don't feel like finding the script?
Don't feel like using `crontab -e` and copy-pasting?

Just run:

```sh
runcron
```

You'll see a list of your cron jobs, like:

```
🕒 Your Cron Jobs
─────────────────────────────

[1]
  */15 * * * * redis-cli flushall && sh /home/ubuntu/api/run_warm_cache.sh --days 180 >> /home/ubuntu/cache_warm.log 2>&1

[2]
  0 2 * * * /usr/bin/python3 /home/ubuntu/scripts/backup_db.py >> /home/ubuntu/backup.log 2>&1

[3]
  30 6 * * 1 /usr/bin/bash /home/ubuntu/scripts/weekly_report.sh --email admin@example.com

Select a job to run [1-3]:
```

Select a job number and it will run the command for you.

---

## 📝 Code

Here is the current runcron code:

```bash
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
cronjobs=$(crontab -l 2>/dev/null | grep -vE '^\t*#|^\t*$')
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
```

[View on GitHub](https://github.com/joshaxelman/runcron)

---

## ℹ️ About

🕒 **runcron** was "vibe coded" in just a few hours using Cursor, a next-generation AI-powered IDE. The project is a testament to how quickly ideas can become reality when you trust the tools and let creativity flow. What started as a simple itch—to run cron jobs without the hassle—became a polished, interactive tool in a single session of focused, modern development.

As an engineer with 27 years of experience, I remember when Dreamweaver and Frontpage generated code that we all avoided, and handwritten code was the only way to ensure quality. For decades, I believed that only code written by hand could be trusted. But the landscape has changed. Today, with tools like Cursor and AI assistance, we can build robust, beautiful, and maintainable software faster than ever before—without sacrificing quality or control.

runcron is more than just a utility; it's a small celebration of how far our craft has come. If you're curious about the future of coding, or just want to run your cron jobs with style, give it a try.

— Josh. Mobile, Web, Cloud/DevOps Engineer. Builder. Semi-professional Dentist. Unlicensed Tattoo Artist. Ancient Alien Theorist. Freelance Pharmacist. Part-time Magician. Full-time Pug Chauffeur. Professional Complainer.

*AI wrote this too*
