#This makefile is for the Image Processor Core testing using DPI calls 

#Specify the mode- could be either puresim or veloce
#Always make sure that everything works fine in puresim before changing to veloce

#MODE ?= veloce
MODE ?= puresim

#make all does everything
all: clean lib compile run

lib:
ifeq ($(MODE),puresim)
	vlib work.$(MODE)
	vmap work work.$(MODE) 
else	
	vellib work.$(MODE)
	velmap work work.$(MODE)
endif

compile:
ifeq ($(MODE),puresim)
	vlog ../Packages.sv ../CellProcessor_int.sv ../CellProcessor.sv hdl/veloce_top.sv -dpiheader tbxbindings.h 
	vlog hvl/ImageProcessorTestBench.cxx 
else
	velanalyze ../Packages.sv ../CellProcessor_int.sv ../CellProcessor.sv hdl/veloce_top.sv
	#Note that the ImageProcessorTestBench.cxx file is passed to velcomp in veloce.config file. That way it knows this is the CoModel and compiles, then later runs on workstation
	velcomp
endif
                                                           
run:
ifeq ($(MODE),puresim)
	vsim -c veloce_top -do "run -all" | tee transcript.puresim
else
	velrun $(RUNTIME_OPTS) | tee transcript.veloce
endif
                                                                                
clean:
	rm -rf edsenv transcript modelsim.ini transcript.veloce veloce.puresim transcript.puresim veloce.map veloce.wave velrunopts.ini work work.veloce veloce.out veloce.med veloce.log tbxbindings.h work.puresim

