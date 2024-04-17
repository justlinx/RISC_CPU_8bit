all : com clean

com:
	vcs +lint=TFIPC-L -full64 -sverilog -debug_all -f run.f -R
clean:
	rm -rf *.log ./sim/* ./work/* *.rpt
