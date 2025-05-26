#!/bin/bash

dir="$HOME/.config/rofi/launchers/type-1"
theme='style-1'

declare -A URLS

URLS=(
  ["brave"]="https://search.brave.com/search?q="
  ["github"]="https://github.com/search?q="
  ["stackoverflow"]="http://stackoverflow.com/search?q="
  ["youtube"]="https://www.youtube.com/results?search_query="
)

# List for rofi
gen_list() {
    for i in "${!URLS[@]}"
    do
      echo "$i"
    done
}

main() {
  # Pass the list to rofi
  platform=$( (gen_list) | rofi -dmenu -matching fuzzy -no-custom -location 0 -p "Platform: " -theme ~/.config/rofi/menu.rasi)

  if [[ -n "$platform" ]]; then
    query=$( (echo ) | rofi  -dmenu -matching fuzzy -location 0 -p "Search: " -theme ~/.config/rofi/menu.rasi)

    if [[ -n "$query" ]]; then
      url=${URLS[$platform]}$query
      xdg-open "$url"
    else
      exit
    fi

  else
    exit
  fi
}

main

exit 0