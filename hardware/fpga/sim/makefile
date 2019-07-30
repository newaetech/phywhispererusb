NUM_EVENTS=20
DELAY_MODE=0
MIN_DELAY=0
MAX_DELAY=20
LOGFILE=sim.log
SEED=0
VERBOSE=0
WAVEFORMAT=fst

all: compile run

compile:
	iverilog -ccmdfile \
	-g2005-sv \
	-Wportbind \
	-Wselect-range \
	-P tb_pw.pNUM_EVENTS=$(NUM_EVENTS) \
	-P tb_pw.pDELAY_MODE=$(DELAY_MODE) \
	-P tb_pw.pMIN_FE_DELAY=$(MIN_DELAY) \
	-P tb_pw.pMAX_FE_DELAY=$(MAX_DELAY) \
	-P tb_pw.pSEED=$(SEED) \
	-P tb_pw.pVERBOSE=$(VERBOSE)

run:
	vvp -l$(LOGFILE) a.out -$(WAVEFORMAT)

clean:
	rm -f a.out
