NUM_EVENTS=20
NO_CAPTURE_LIMIT=0
NUM_REPEATS=1
DELAY_MODE=0
MIN_DELAY=0
MAX_DELAY=20
PRETRIG_MAX=200
PATTERN_MIN=4
PATTERN_MAX=16
VALID=50
LOGFILE=sim.log
SEED=0
VERBOSE=0
TIMEOUT=50000
TRIGGER_ENABLE=0
READ_CONCURRENTLY=1
STREAM_MODE=0
SLOW_READS=0
TRIGGER_DELAY_MIN=0
TRIGGER_DELAY_MAX=512
TRIGGER_WIDTH_MIN=1
TRIGGER_WIDTH_MAX=512
NUM_TRIGGERS_MIN=1
NUM_TRIGGERS_MAX=8
OVERFLOW=0
MAX_TIMESTAMP=65535
WAVEFORMAT=fst
DUMP=0
TOP=tb_pw

# This here is a bit clumsy, but necessary because iverilog fails to compile
# the Xilinx FIFO if the -s switch is used on the tb_pw testbench:
ifneq ($(TOP),tb_pw)
	TESTBENCH=$(TOP).v
	S=-s $(TOP)
endif


all: compile run

compile:
	iverilog -ccmdfile \
	-g2005-sv \
	-Wportbind \
	-Wselect-range \
	-I../hdl \
	-I../../../software/phywhisperer/firmware \
	$(TESTBENCH) \
	$(S) \
	-P tb_pw.pNUM_EVENTS=$(NUM_EVENTS) \
	-P tb_pw.pNO_CAPTURE_LIMIT=$(NO_CAPTURE_LIMIT) \
	-P tb_pw.pNUM_REPEATS=$(NUM_REPEATS) \
	-P tb_pw.pDELAY_MODE=$(DELAY_MODE) \
	-P tb_pw.pMIN_FE_DELAY=$(MIN_DELAY) \
	-P tb_pw.pMAX_FE_DELAY=$(MAX_DELAY) \
	-P tb_pw.pPRETRIG_BYTES_MAX=$(PRETRIG_MAX) \
	-P tb_pw.pPATTERN_BYTES_MIN=$(PATTERN_MIN) \
	-P tb_pw.pPATTERN_BYTES_MAX=$(PATTERN_MAX) \
	-P tb_pw.pPVALID=$(VALID) \
	-P tb_pw.pSEED=$(SEED) \
	-P tb_pw.pTIMEOUT=$(TIMEOUT) \
	-P tb_pw.pTRIGGER_ENABLE=$(TRIGGER_ENABLE) \
	-P tb_pw.pREAD_CONCURRENTLY=$(READ_CONCURRENTLY) \
	-P tb_pw.pSTREAM_MODE=$(STREAM_MODE) \
	-P tb_pw.pSLOW_READS=$(SLOW_READS) \
	-P tb_pw.pTRIGGER_DELAY_MIN=$(TRIGGER_DELAY_MIN) \
	-P tb_pw.pTRIGGER_DELAY_MAX=$(TRIGGER_DELAY_MAX) \
	-P tb_pw.pTRIGGER_WIDTH_MIN=$(TRIGGER_WIDTH_MIN) \
	-P tb_pw.pTRIGGER_WIDTH_MAX=$(TRIGGER_WIDTH_MAX) \
	-P tb_pw.pNUM_TRIGGERS_MIN=$(NUM_TRIGGERS_MIN) \
	-P tb_pw.pNUM_TRIGGERS_MAX=$(NUM_TRIGGERS_MAX) \
	-P tb_pw.pOVERFLOW_EXPECTED=$(OVERFLOW) \
        -P tb_pw.pMAX_TIMESTAMP=$(MAX_TIMESTAMP) \
	-P tb_pw.pVERBOSE=$(VERBOSE) \
	-P tb_pw.pDUMP=$(DUMP) \

nofifo:
	iverilog -ccmdfile_nofifo \
	-g2005-sv \
	-Wportbind \
	-Wselect-range \
	-I../hdl \
	-I../../../software/phywhisperer/firmware \
	-DNOFIFO \

run:
	vvp -l$(LOGFILE) a.out -$(WAVEFORMAT)

clean:
	rm -f a.out
