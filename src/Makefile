#Makefile for Legacy ICE Mode (Standalone) for VeloceOS3 flow 
#standalone_tutorial_1 
#Author-Sameer Ghewari, April 2015

all: clean lib analyze vmwclk compile run view  


lib: 
	vellib work
	velmap work ./work 
	
	
analyze: lib
	-velcomp
	@echo -e "\nMakeInfo: You may get an error informing vmw.clk.generated file is missing if you are running this the first time. \n\tThis is normal, do not panic! You will generate this file using GUI in the next step\n"
	
vmwclk: analyze
	@echo -e "\nMakeInfo: Now Use velview to create vmw.clk clock/IO specification file. Follow steps from Standalone Flow guide. \n\t\tPress enter to continue....."
	@read
	velview 
	
compile: vmwclk
	velcomp -start_after rtlc 
	
run: compile
	velrun -nac -c -do run.do
	@echo -e "\nMakeInfo: Emulation run successful!"
	
view: run
	@echo -e "\nMakeInfo: Will open velview GUI now and add wave/signals using do file"
	velview -do view.do
	
clean:
	rm -rf edsenv debussy.cfg DEBUG_AllBoardsInfos_Host_0.txt veloce.log veloce.med veloce.map veloce.wave velrunopts.ini work 

