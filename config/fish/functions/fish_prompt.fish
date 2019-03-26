function fish_prompt
	test $SSH_TTY
    and printf (set_color red)$USER(set_color brwhite)'@'(set_color yellow)(prompt_hostname)' '
    test "$USER" = 'root'
    and echo (set_color red)"#"

    # Main
    if set -q VIRTUAL_ENV
        echo -n -s (set_color -b blue white) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
    end

    set arr '❯'
    if test "$TERM" = "linux"
	   set arr '>'
    end
    # if set -q VIRTUAL_ENV
    #    echo -n -s (set_color -b blue white) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
    # end
    echo -n (set_color cyan)(prompt_pwd) (set_color red)"$arr"(set_color yellow)"$arr"(set_color green)"$arr "
end

function ls --wraps ls
	command ls --color=auto $argv
end

function l --wraps ls
	ls -lah $argv
end

function dmesg --wraps dmesg
	command dmesg --color=always --reltime $argv
end

function dmesgwatch --wraps dmesg
	set lc 10
	watch -ct "dmesg --color=always --reltime $argv | tail -n $lc"
end
