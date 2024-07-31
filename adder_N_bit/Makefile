.SUFFIXES:

PATTERN = adder_N_bit

all:  ${PATTERN:=.vcd}

%.vvp: %_tb.sv
	iverilog -g 2012 -Y .sv -y $(shell pwd) ${PATTERN:=.sv} \
	$< -o $@

%.vcd: %.vvp
	vvp $<

clean:
	rm -f *.vvp *.vcd

.PHONY: clean all