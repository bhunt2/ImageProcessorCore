# Makefile for Legacy ICE Mode (Standalone) use of Veloce
# and for questa sim
# Image Processor Core
# Author-Benjamin Huntsman 2015

# Make methods when using veloce
vall: vclean vlib vanalyze vmwclk vcompile vrun vview  


vlib: 
	vellib work
	velmap work ./work 
	
	
vanalyze: vlib
	-velcomp
	@echo -e "\nMakeInfo: You may get an error informing vmw.clk.generated file is missing if you are running this the first time. \n\tThis is normal, do not panic! You will generate this file using GUI in the next step\n"
	
vmwclk: vanalyze
	@echo -e "\nMakeInfo: Now Use velview to create vmw.clk clock/IO specification file. Follow steps from Standalone Flow guide. \n\t\tPress enter to continue....."
	@read
	velview 
	
vcompile: vmwclk
	velcomp -start_after rtlc 
	
vrun: vcompile
	velrun -nac -c -do run.do
	@echo -e "\nMakeInfo: Emulation run successful!"
	
vview: vrun
	@echo -e "\nMakeInfo: Will open velview GUI now and add wave/signals using do file"
	velview -do view.do

vclean:
	rm -rf edsenv debussy.cfg DEBUG_AllBoardsInfos_Host_0.txt veloce.log veloce.med veloce.map veloce.wave velrunopts.ini work 

#Make methods when using questa
qall: qclean qlib qcompile qrun


qlib: 
	vlib work	
	
qcompile: lib
	vlog -f compile_list.txt
	@echo -e "Compiling project."
	
qrun: compile
	vsim -c TestBench
	@echo -e "Running project."
	
qclean:
	rm -rf ./work transcript
