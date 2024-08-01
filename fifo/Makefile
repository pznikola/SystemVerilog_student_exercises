.SUFFIXES:

PATTERN = fifo

all:  ${PATTERN:=.vcd}

%.vvp: %_tb.sv
	iverilog -g 2012 -Y .sv -y $(shell pwd) ${PATTERN:=.sv} \
	$< -o $@

%.vcd: %.vvp
	vvp $<
	gtkwave ${PATTERN:=.vcd}

clean:
	rm -f *.vvp *.vcd

.PHONY: clean all