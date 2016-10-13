# SET THE C++ COMPILER
#CC = mpic++
#CC = CC
CC = gfortran
#CCJazz = mpiCC

# SET THE C++ LINKER
# i. this may be the same as the C++ compiler
#CCL = mpic++
#CCL = CC
CCL = gfortran
#CCJazz = mpiCC

# SET THE C++ COMPILER FLAGS
CFLAGS = -c -O3 

# SET THE PATH TO THE JSCIENCE LIBRARY
#JSCIPATH=../jscience/

# SOURCE CODE PATH FOR JFEM3D
SRCPATH1=./src/BARYCENTER/
SRCPATH2=./src/OVERLAP/

# EXECUTABLE PATH
BINPATH=./bin/

# WORKING PATH
#WKPATH=./tmp/

# SCRIPTS PATH
SCRIPTSPATH=./scripts/

# DOC PATH
DOCPATH=./doc/

# TEST_DADA PATH 
TEST_DADA_PATH=./test-data/


############################################################
# install PATH  
# modify it if you want to install the code in a new path 
CALC_BC_OP_LD_PATH=/public/home/tucy/software/CALC_BC_OP_LD/

#############################################################


# OBJECT FILES FOR THIS PROGRAM
OBJS1 = $(SRCPATH1)BARYCENTER.o 
OBJS2 = $(SRCPATH2)OVERLAP.o    

all:  BARYCENTER    OVERLAP

BARYCENTER: BARYCENTER.o 
	$(CCL) $(OBJS1) -o BARYCENTER

BARYCENTER.o: 
	$(CC) $(CFLAGS) $(SRCPATH1)BARYCENTER.f90  -o $(SRCPATH1)BARYCENTER.o

OVERLAP: OVERLAP.o  
	$(CCL) $(OBJS2) -o OVERLAP

OVERLAP.o:
	$(CC) $(CFLAGS) $(SRCPATH2)OVERLAP.f90  -o  $(SRCPATH2)OVERLAP.o

# define install object 
install: 
	mkdir   $(BINPATH)  $(WKPATH) 2>/dev/null 
	cp   BARYCENTER    OVERLAP   $(BINPATH)
#	cp   $(SCRIPTSPATH)*.sh    BARYCENTER    OVERLAP   $(WKPATH) 
	mkdir   $(CALC_BC_OP_LD_PATH)bin   $(CALC_BC_OP_LD_PATH)scripts      $(CALC_BC_OP_LD_PATH)doc     $(CALC_BC_OP_LD_PATH)test-data    2>/dev/null 
	cp  -r   $(BINPATH)      $(CALC_BC_OP_LD_PATH)  
	cp  -r   $(SCRIPTSPATH)  $(CALC_BC_OP_LD_PATH)  
	cp  -r   $(DOCPATH)       $(CALC_BC_OP_LD_PATH)  
	cp  -r   $(TEST_DADA_PATH)   $(CALC_BC_OP_LD_PATH) 
	cp    calc_BC_OP_LD.sh   README    $(CALC_BC_OP_LD_PATH)  


# define clean object 
clean:
	rm  -f  $(SRCPATH1)*.o   $(SRCPATH2)*.o    BARYCENTER  OVERLAP   2>/dev/null  

clean_all:
	rm  -f  $(SRCPATH1)*.o   $(SRCPATH2)*.o    BARYCENTER  OVERLAP  2>/dev/null 
	rm  -rf  $(BINPATH)     2>/dev/null  
	rm  -rf     $(CALC_BC_OP_LD_PATH)bin   $(CALC_BC_OP_LD_PATH)scripts   $(CALC_BC_OP_LD_PATH)doc    $(CALC_BC_OP_LD_PATH)test-data   2>/dev/null  
	rm  -f   $(CALC_BC_OP_LD_PATH)*.sh    $(CALC_BC_OP_LD_PATH)README    2>/dev/null  

#end 
