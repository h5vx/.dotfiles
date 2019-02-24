#!/bin/sh

case "${DESKTOP_SESSION-}" in
	awesome|dwm)
		setxkbmap -layout us,ru -option grp:alt_shift_toggle,compose:ralt
		/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
		;;
esac

exec $DESKTOP_SESSION
