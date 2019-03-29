function dmesg --wraps dmesg
	command dmesg --color=always --reltime $argv
end

