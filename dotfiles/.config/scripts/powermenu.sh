#! /bin/sh

rofi_cmd() {
	rofi -dmenu \
		-theme ~/.config/rofi/powermenu.rasi
}

chosen=$(printf "⏻ poweroff\n󰜉 reboot\n lock\n󰗼 exit" | rofi_cmd)

case "$chosen" in
	"⏻ poweroff") poweroff ;;
	"󰜉 reboot") reboot ;;
	" lock") exec ~/.config/scripts/lock.sh ;;
	"󰗼 exit") bspc quit ;;
esac
