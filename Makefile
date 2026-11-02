RTL := $(wildcard rtl/*.v)

# make run-tb_alu  ->  compile και εκτέλεση του tb/tb_alu.v
run-%: sim/%.vvp
	vvp $<

sim/%.vvp: tb/%.v $(RTL) | sim
	iverilog -g2005 -Wall -s $* -o $@ $< $(RTL)

sim:
	mkdir -p sim

tests:
	bash sw/build_tests.sh

check:
	bash sw/run_tests.sh

clean:
	rm -rf sim

.PHONY: clean tests check
.PRECIOUS: sim/%.vvp
