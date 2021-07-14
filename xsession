#!/bin/sh

case "${DESKTOP_SESSION-}" in
	awesome|dwm)
		/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
		picom -b
		xss-lock -- ~/.local/bin/lock &
		guake &
		xxkb &
		nm-applet &
		udiskie -t &
        redshift-gtk &
        kdeconnect-indicator &

		firefox &
		telegram-desktop &
		;;
esac

eval `ssh-agent -s`; ssh-add < /dev/null

# exec $DESKTOP_SESSION
