function dmesgwatch --wraps dmesg
	set lc 10
	watch -ct "dmesg --color=always --reltime $argv | tail -n $lc"
end

