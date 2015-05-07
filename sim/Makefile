# Makefile for Legacy ICE Mode (Standalone) use of Veloce
# and for questa sim
# Image Processor Core
# Author-Benjamin Huntsman 2015

# Make methods when using veloce
vall: vclean vlib vanalyze vmwclk vcompile vrun vview  

#Setup VNC server on veloce VM
vserver: 
	vncserver

#Check to see if someone is on the emulator
vwhoison:
	whoison -emul velocesolo1
	
#Setup working directory for veloce
vlib: 
	vellib work
	velmap work ./work 	

#Compile project
vanalyze:
	-velcomp
	@echo -e "\nMakeInfo: You may get an error informing vmw.clk.generated file is missing if you are running this the first time. \n\tThis is normal, do not panic! You will generate this file using GUI in the next step\n"

#Create clock
vmwclk: 
	@echo -e "\nMakeInfo: Now Use velview to create vmw.clk clock/IO specification file. Follow steps from Standalone Flow guide. \n\t\tPress enter to continue....."
	@read
	velview 

#Compile and start rtlc
vcompile: 
	velcomp -start_after rtlc 
	
#Run the test
vrun: 
	velrun -nac -c -do run.do
	@echo -e "\nMakeInfo: Emulation run successful!"

#View the wave diagram
vview: vrun
	@echo -e "\nMakeInfo: Will open velview GUI now and add wave/signals using do file"
	velview -do view.do

#Clean the project
vclean:
	rm -rf edsenv debussy.cfg DEBUG_AllBoardsInfos_Host_0.txt veloce.log veloce.med veloce.map veloce.wave velrunopts.ini work 


#Make methods when using questa
qall: qclean qlib qcompile qrun

#Setup working directory
qlib: 
	vlib work	

#Compile project
qcompile:
	vlog -f compile_list.txt
	@echo -e "Compiling project."

#Run the test
qrun:
	vsim -c TestBench
	@echo -e "Running project."

#Clean the project
qclean:
	rm -rf ./work transcript
