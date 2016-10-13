######################################
# calc_BC_OP_LD.sh
By Chunyun Tu 
Email: yidapa@yeah.net  
 
Date: 2016-10-12 

No warranty, no liability; 
you use this at your own risk.  
You are free to modify and 
distribute this without giving 
credit to the original author. 
#####################################

# Purpose and usage of the code 
	This small fortran code is a postscript to calculate the barycenters of HOMO, LUMO orbital,
or the modular overlap between them (needs .fchk file); it can also calculate the spatial overlap 
of an electronic excitation (needs CIS or TD(A)-DFT .fchk and .log).  
It's meant to be used in GNU/Linux environment. 
It is driven by a bash script, calc_BC_OP_LD.sh  
It runs in batch mode, although it can also treat only one input file (Guassian .fchk files).
Run the executable  calc_BC_OP_LD.sh  where the input .fchk files or .log locate; simply run 
it without file arguments but with -a or -b or -c  options to indicate the job type. 
-a will calculate the barycenters;
-b will calculate the modular_overlap.
-c will calculate the lambda (spatial overlap) of an excitation. 
-d CLEAN_ALL  will clean the tmp dir for new run. 

calc_BC_OP_LD.sh  -a  -b  -c  -d CLEAN_ALL 

Run the script with option -h, and the help information will explain itself.  
calc_BC_OP_LD.sh   -h 

# License
 This code is under the 3rd version of the GNU Public License (GPL.v3).  
You are free to use, modifcy, distribute it, suppose it is 
useful for your project.  

# Dependence on Environment 
	The computational-intense part of the code  is written in Fortran 90, 
and all scripts are written in bash. 
For compiling the .f90 source, F90 compiler (gfortran or ifort) is needed. 
The scripts made heavily use of grep, sed, awk, wl, etc, which are standard text 
tools in any GNU/Linux distribution. 
	The Guassian cubegen utility should exist in your system, and can be find anywhere.

# Problems 
	Since my understanding on the structure of Gaussian .fchk is very limited, 
in the implementation, I unwisely call the Gaussian cubegen ultility to make the 
read-and-write of MO cofficents easierly.  Thus, the cost of time via this approach 
is dominated by the calling of cubegen. Though it does work, I hope this problem 
could be overcome later.

# Reference 
For definition of spatial overlap (Lambda) of an excitation
1.) Peach, M. J. G., Benfield, P., Helgaker, T. & Tozer, D. J. Excitation energies in density functional theory: An evaluation and a diagnostic test. The Journal of Chemical Physics 128, 44118 (2008).


# Installation 
1. uncompress the tar.gz source 
	tar -zxvf  calc_BC_OP_LD_v1.0.tar.gz  
2. enter the directory calc_BC_OP_LD_v1.0 
	cd  calc_BC_OP_LD_v1.0/ 
3. install via gnu make 
	Firstly, define the install path via the following shell enviroment variable. The some_valid_path
is absolute path belonging to an empty dir, eg, /public/tucy/software/calc_BC_OP_LD/ 
It's better to append the following to your ~/.bashrc  file, then source  ~/.bashrc  
export CALC_BC_OP_LD_PATH=some_valid_path 


	Seconly, edit the install path variable line in makefile to  CALC_BC_OP_LD_PATH=some_valid_path  

	Thirdly, apply the following cmds, and after successful installation, the compiling dir can
be removed totally. 
	make  all
	make  install 
	make  clean

	Finally, to make the main driven script  calc_BC_OP_LD.sh  visible at arbitrary path, it's recommend 
to add  $CALC_BC_OP_LD_PATH  to  $PATH, or you can copy  it  to  ~/bin/ 


# Test 
  For test of correct installation, change path to the ${CALC_BC_OP_LD_PATH}test-data dir, and enter 
	calc_BC_OP_LD.sh  -a -b -d CLEAN 
	calc_BC_OP_LD.sh  -c  -d CLEAN 
Then, the summary of the calcualtion will be printed to the screen.

NOTE: The script should  be run in batch mode.  
Option -a and -b can be applied together; -c should be called uniquely. 
Though the time cost might increase considerably, it's recommend to clean 
the directory before calling  ( -a -b )  or ( -c ).
    calc_BC_OP_LD.sh  -d   CLEAN 
if get confused, try  
    calc_BC_OP_LD.sh  -h  

1.) structure of .tddata file
	A. the original CI coefficients in .log 
 Excited State   1:      Singlet-A      2.4306 eV  510.11 nm  f=0.0029  <S**2>=0.000
     112 ->115        -0.01602
     114 ->115         0.70230
     114 ->117        -0.07543
     114 ->123        -0.01912
 This state for optimization and/or second-order correction.

  B. the correspondig data in .tddata file 
     112   115        -0.01602
     114   115         0.70230
     114   117        -0.07543
     114   123        -0.01912

	Throug using .tddata files, the user might have more freedom to scale the calculation, the data now
becomes not restricted only to "Excited State   1:", it can be another, e.g., "Excited State   5:". 
Remember that test1-td.tddata could be generated if test1-td.log was provided. 


# END 
