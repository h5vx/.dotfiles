function j2me -d "Launch J2ME emulator on jad/jar file" -a jadfile
	if test -z $jadfile
		echo "Usage: $argv[0] <jadfile|jarfile>"
		return
	end
	if test (string split -r '.' $jadfile)[-1] = 'jar'
		set tmpdir /tmp
		set jarfile $jadfile
		set jadfile $tmpdir/(basename $jadfile).jad
		/home/user/scripts/jar2jad -o $tmpdir $jarfile
	end
	/opt/sun-wtk/bin/emulator -Xdescriptor:$jadfile
end

