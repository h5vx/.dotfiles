function toggleconf -d "Add/Remove '.off' filename suffix, useful to disable/enable some configs" -a fname
	function toggle_fname --no-scope-shadowing -d "Adds/Removes '.off' in fname"
		set old_fname $fname

		if string match "*.off" $fname
			set -l fname_length (string length $fname)
			set fname (string sub -l (math $fname_length - 4) $fname)
		else
			set fname "$fname.off"
		end
	end

	if test -z $fname
		set_color red; echo "Usage: toggleconf <file>"; set color normal
		return
	end

	if test ! -e $fname
		toggle_fname  # Check if file is already toggled

		if test ! -e $fname
			set_color red; echo "File '$old_fname' doesn't exists"; set color normal
			return
		end
	end
	
	toggle_fname
	
	if test -e $fname
		set -l answer (read -n1 -P "File '$fname' already exists! Overwrite? [y/N]: ")
		if test ! (string lower $answer) = "y"
			return
		end
	end

	set mv_cmd "mv"
	set file_owner_uid (stat --printf="%u" $old_fname)
	if test $file_owner_uid = "0"
		set mv_cmd "sudo" "mv"
	end

	$mv_cmd $old_fname $fname
	
	if test $status = 0
		set_color green; echo -n "$old_fname"; set_color normal; echo -n " -> "; 
		set_color green; echo "$fname"; set_color normal;
	else
		set color red; echo "Failed to move file, code $status"
	end
end

