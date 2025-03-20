#! /bin/sh

rofi_cmd() {
	rofi -dmenu \
		-theme ~/.config/i3/rofi/powermenu.rasi
}

chosen=$(printf "⏻ poweroff\n󰜉 reboot\n lock\n󰗼 exit" | rofi_cmd)

case "$chosen" in
	"⏻ poweroff") poweroff ;;
	"󰜉 reboot") reboot ;;
	" lock") exec ~/.config/i3/scripts/lock.sh ;;
	"󰗼 exit") bspc quit ;;
esac
