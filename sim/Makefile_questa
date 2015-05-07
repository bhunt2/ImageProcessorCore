#Makefile for Legacy ICE Mode (Standalone) for VeloceOS3 flow 
#standalone_tutorial_1 
#Author-Sameer Ghewari, April 2015

all: clean lib compile run


lib: 
	vlib work	
	
compile: lib
	vlog -f compile_list.txt
	@echo -e "Compiling project."
	
run: compile
	vsim -c TestBench
	@echo -e "Running project."
	
clean:
	rm -rf ./work transcript

