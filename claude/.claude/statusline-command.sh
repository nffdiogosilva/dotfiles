#!/usr/bin/env bash
# Claude Code status line — mirrors Starship-style prompt info + Claude context

input=$(cat)

cwd_raw=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
# Shorten home directory to ~ for display only
cwd="${cwd_raw/#$HOME/~}"

model=$(echo "$input" | jq -r '.model.display_name // empty')

# Git branch (skip optional locks) — use raw path, not the tilde-shortened one
git_branch=$(git -C "$cwd_raw" --no-optional-locks branch --show-current 2>/dev/null)

# Context window remaining
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Rate limits (5-hour and 7-day)
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Git dirty state
git_dirty=""
if [ -n "$git_branch" ]; then
  [ -n "$(git -C "$cwd_raw" --no-optional-locks status --porcelain 2>/dev/null)" ] && git_dirty=" *"
fi

# Git ahead/behind tracking branch
git_ab=""
if [ -n "$git_branch" ]; then
  ab=$(git -C "$cwd_raw" --no-optional-locks rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)
  if [ -n "$ab" ]; then
    ahead=$(echo "$ab" | cut -f1)
    behind=$(echo "$ab" | cut -f2)
    [ "$ahead" -gt 0 ] 2>/dev/null && git_ab="${git_ab} ↑${ahead}"
    [ "$behind" -gt 0 ] 2>/dev/null && git_ab="${git_ab} ↓${behind}"
  fi
fi

# Build prompt parts
location_part="${cwd}"
[ -n "$git_branch" ] && location_part="${location_part} (${git_branch}${git_dirty})${git_ab}"

meta_parts=""
[ -n "$model" ] && meta_parts="${model}"
[ -n "$remaining" ] && meta_parts="${meta_parts:+$meta_parts | }ctx:$(printf '%.0f' "$remaining")% left"
[ -n "$five_pct" ] && meta_parts="${meta_parts:+$meta_parts | }5h:$(printf '%.0f' "$five_pct")%"
[ -n "$week_pct" ] && meta_parts="${meta_parts:+$meta_parts | }7d:$(printf '%.0f' "$week_pct")%"

if [ -n "$meta_parts" ]; then
  printf '%s  |  %s' "$location_part" "$meta_parts"
else
  printf '%s' "$location_part"
fi
