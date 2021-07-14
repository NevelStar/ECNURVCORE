PHONY:comp sim debug list clean

export NOVAS_HOME=/EDA/synopsys/VERDI/verdi/Verdi_O-2018.09-SP2
export NOVAS=${NOVAS_HOME}/share/PLI/VCS/LINUX64
export novas_args=-P $NOVAS/novas.tab $NOVAS/pli.a

LIST = find -name "*.v" > rtl.f

SIM = ./simv -l simv.log

VCS = vcs -full64\
	+vcs+lic+wait\
	-simprofile\
	-sverilog +v2k\
	-debug_all \
	-timescale=1ns/1ns\
	-P ${NOVAS}/novas.tab ${NOVAS}/pli.a\
	-l compile.log\

list:
	${LIST} 

comp:
	${VCS} -f rtl.f

sim:
	${SIM} 

debug:
	verdi -f rtl.f -ssf wave.fsdb &

clean:
	rm -rf  *.daidir simv* *.log *.fsdb *.fsdb.* csrc novas.* verdiLog ucli.key
