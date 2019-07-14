#!/bin/sh

case "${DESKTOP_SESSION-}" in
	awesome|dwm)
		setxkbmap -layout us,ru -option grp:alt_shift_toggle,compose:ralt,grp_led:scroll
		/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
		compton -b
		xss-lock -- i3lock -c000000 &
		tilda &
		xxkb &
		nm-applet &
		;;
esac

eval `ssh-agent -s`; ssh-add < /dev/null

exec $DESKTOP_SESSION
