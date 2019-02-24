function cfr_midp -d "Decompile J2ME using CFR" -a jarfile outdir
	if test -z $outdir
		set outdir {$jarfile}_CFR
	end
	cfr $jarfile --hideutf false --extraclasspath /opt/sun-wtk/lib/midpapi21.jar --outputdir $outdir $argv[3..-1]
end 
