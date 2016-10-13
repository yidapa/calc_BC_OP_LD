#!/bin/bash
 
######################################################################
#This is an example of using getopts in Bash. It also contains some
#other bits of code I find useful.
#Author: Linerd
#Website: http://tuxtweaks.com/
#Copyright 2014
#License: Creative Commons Attribution-ShareAlike 4.0
#http://creativecommons.org/licenses/by-sa/4.0/legalcode
######################################################################

# Set the install main path 
if [ "${CALC_BC_OP_LD_PATH}" != "" ]; then
	CALC_BC_OP_LD_PATH=${CALC_BC_OP_LD_PATH} 
else
	CALC_BC_OP_LD_PATH=./
fi


#Set Script Name variable
SCRIPT=`basename ${BASH_SOURCE[0]}` 
#Initialize variables to default values.
OPT_A=BARYCENTER
OPT_B=OVERLAP
OPT_C=LAMBDA
OPT_D=CLEAN
#OPT_D=D
 
#Set fonts for Help. 
NORM=`tput sgr0`
BOLD=`tput bold`
REV=`tput smso`


#-------------set start time for Code diagnosis 
start_time=$(date "+%s")


#--------------------------functions------------------------------------- 
#Help function
function HELP {

echo -e \\n"Help documentation for ${BOLD}${SCRIPT}.${NORM}"\\n
echo -e "${REV}Basic usage:${NORM} ${BOLD}${SCRIPT} "\\n
echo "Command line switches are optional. The following switches are recognized."
echo "${REV}-a${NORM}  --Sets the value for option ${BOLD}a${NORM}. Default is ${BOLD}BARYCENTER${NORM}."
echo "${REV}-b${NORM}  --Sets the value for option ${BOLD}b${NORM}. Default is ${BOLD}OVERLAP${NORM}."
echo "${REV}-c${NORM}  --Sets the value for option ${BOLD}d${NORM}. Default is ${BOLD}LAMBDA${NORM}."
echo "${REV}-d${NORM}  --Sets the value for option ${BOLD}c${NORM}. Default is ${BOLD}CLEAN${NORM}."
#echo "${REV}-d${NORM}  --Sets the value for option ${BOLD}d${NORM}. Default is ${BOLD}D${NORM}."
echo -e "${REV}-h${NORM}  --Displays this help message. No further functions are performed."\\n
#echo -en "#   \e[33m       # color of string: yellow    \n"
echo -e "---------------------------------------------------------------------------------"
echo -e "For correct use of the this script, please copy the Guassian fchk files to ./tmp , "
echo -e "and then use:"
echo -en "Example:\e[33m ${BOLD}$SCRIPT  -a   -b   -c   -d  CLEAN_ALL ${NORM} \n" 
echo -e "-a  will calculate the barycenters of HOMOs, LUMOs." 
echo -e "the output file is ${CALC_BC_OP_LD_PATH}tmp/BARYCENTER_distance.outfile "
echo -e "-b  will calculate the modular overlap between HOMO and LUMO."
echo -e "the output file is ${CALC_BC_OP_LD_PATH}tmp/OVERLAP_overlap.outfile "
echo -e "if -a  -b  are both provided, then BARYCENTER, OVERLAP will bothly be calculated." 
echo -e "-c will calculate the LAMBDA (spatial overlap) of an excitation. "
echo -e "the output file is ${CALC_BC_OP_LD_PATH}tmp/LAMBDA_lambda.outfile " 
echo -e "Provided that the .fchk and the same name .tddata files are supplied. "
echo -e "The .tddata files can be automatically generated if .log files are avialiable. "
echo -e "-d CLEAN will clean all tempt files including the output files. "
echo -e "-d CLEAN_ALL will clean all tempt files, output files, and input files. "\\n 
echo -e "Notice:  option  -a  -b can be used together, option -c should be used singly,"
echo -e "because -a -b depends on the same input file (.fchk only), while -c depends on "
echo -e "totally differnt input files (.fchk and .tddata). "
echo -e "Always remember to clean the ${CALC_BC_OP_LD_PATH}tmp directory before you perform  -a, -b, or -c jobs. "
echo -e "${SCRIPT}  -d  CLEAN_ALL " \\n 
exit 1
}

# test input fchk files  exist in ${CALC_BC_OP_LD_PATH}tmp 
# funciton  

# function creat_hn_cubes 
function CREAT_HN_CUBE {
if [ ! -f ${CALC_BC_OP_LD_PATH}bin/OVERLAP ]  ||  [ ! -f ${CALC_BC_OP_LD_PATH}bin/BARYCENTER ];  then 
	echo -e "ERROR: executable do not exist. Check,"
	echo -e "${CALC_BC_OP_LD_PATH}bin/OVERLAP " 
	echo -e "${CALC_BC_OP_LD_PATH}bin/BARYCENTER"
	exit 1
fi 

#number_scripts=`ls -l ${CALC_BC_OP_LD_PATH}scripts/*.sh   | wc -l `
#if [  $number_scripts -ne 8  ];  then 
#   echo -e "ERROR: scripts do not exist. Check, "
#   echo -e "${CALC_BC_OP_LD_PATH}scripts/"
#   exit 1
#fi 

number_fchk_files=`ls -l  *.fchk | wc -l `
if [ $number_fchk_files -eq 0 ]; then
	echo -e "Servere ERROR."
	echo -e "No fchk file exist! "
#	echo -e "Please copy fchk files to  ${CALC_BC_OP_LD_PATH}tmp/, and retry"
	exit 1 
fi

echo "Test number of cube: exist or not ? "
echo "If not, creat them via calling cubegen ultility."
number_hn_cube=`ls -l  *-[hn].cube | wc -l `
if [ $number_hn_cube -eq 0 ];  then 
	sh   ${CALC_BC_OP_LD_PATH}scripts/HOMO_LUMO_cubegen_hn.sh
fi 

}


#function CREAT_TDDATA_HN_CUBE 
function CREAT_TDDATA_HN_CUBE {
if [ ! -f ${CALC_BC_OP_LD_PATH}bin/OVERLAP ]  ||  [ ! -f ${CALC_BC_OP_LD_PATH}bin/BARYCENTER ];  then
   echo -e "ERROR: executable do not exist. Check,"
   echo -e "${CALC_BC_OP_LD_PATH}bin/OVERLAP " 
   echo -e "${CALC_BC_OP_LD_PATH}bin/BARYCENTER"
   exit 1
fi

#number_scripts=`ls -l ${CALC_BC_OP_LD_PATH}scripts/*.sh   | wc -l `
#if [  $number_scripts -ne 8  ];  then
#   echo -e "ERROR: scripts do not exist. Check, "
#   echo -e "${CALC_BC_OP_LD_PATH}scripts/"
#   exit 1
#fi

number_fchk_files=`ls -l  *.fchk | wc -l `
if [ $number_fchk_files -eq 0 ]; then
   echo -e "Servere ERROR."
   echo -e "No fchk file exist! "
#   echo -e "Please copy fchk files to  ${CALC_BC_OP_LD_PATH}tmp/, and retry"
   exit 1
fi

#echo "Test number of cube: exist or not ? "
#echo "If not, creat them via calling cubegen ultility."
#number_hn_cube=`ls -l  *-[hn].cube | wc -l `
#if [ $number_hn_cube -eq 0 ] || [ ${number_hn_cube} -lt  $((2*number_fchk_files)) ] ;  then
#   sh   tddata_MOs_cubegen_hn.sh
#fi

sh  ${CALC_BC_OP_LD_PATH}scripts/tddata_MOs_cubegen_hn.sh
if [ $? -ne 0 ]; then
	echo -e "# ERROR: call tddata_MOs_cubegen_hn.sh failed. "
	echo -e "check the number of input .fchk .tddata files. "
	exit 1 
fi

}

# function treat_log_tddata 
function TREAT_LOG_TDDATA {

number_fchk_files=`ls -l  *.fchk | wc -l `
number_log_files=`ls -l *.log | wc -l `

if [ ${number_log_files} -eq 0 ] || [ ${number_fchk_files} -eq 0 ] ||  [ ${number_fchk_files} -ne ${number_log_files} ]; then
   echo -e "Servere ERROR."
   echo -e "The number for .fchk and that for .log is not equal; or one of them is equal to 0! "
	exit 1
else 
	sh ${CALC_BC_OP_LD_PATH}scripts/treat_log_tddata_bat.sh
	if [ $? -ne 0 ]; then
		echo -e "# ERROR: call  treat_log_tddata_bat.sh  failed. "
		echo -e "check the number of input .fchk .log files. "
		exit 1 
	fi
fi 
}

# function CALC_BARYCENTER
function CALC_BARYCENTER {
sh    ${CALC_BC_OP_LD_PATH}scripts/BARYCENTER_bat.sh    ;
sh    ${CALC_BC_OP_LD_PATH}scripts/BARYCENTER_distance.sh ;  
cat   BARYCENTER_distance.outfile ;
}

# function CALC_OVERLAP 
function CALC_OVERLAP {
sh    ${CALC_BC_OP_LD_PATH}scripts/OVERLAP_bat.sh  ;  
sh    ${CALC_BC_OP_LD_PATH}scripts/OVERLAP_overlap.sh  ;  
cat   OVERLAP_overlap.outfile ;
}

# function CALC_LAMBDA
function CALC_LAMBDA {
sh    ${CALC_BC_OP_LD_PATH}scripts/LAMBDA_bat.sh  ;
sh    ${CALC_BC_OP_LD_PATH}scripts/LAMBDA_lambda.sh  ;
cat   LAMBDA_lambda.outfile ;
}


# function CLEAN_TMP_FILES
function  CLEAN_TMP_FILES {
echo -e "remove *-[hn].cube    *.out    *.dat  files." 
rm   -f   *-[hn].cube    *.out    *.dat    2>/dev/null 
}

# function CLEAN_INPUT_FILES
function  CLEAN_INPUT_FILES {
echo -e "remove *.fchk   *.log   *.tddata  *.outfile  files."
rm   -f   *.fchk   *.log   *.tddata  *.outfile  2>/dev/null
}

#Check the number of arguments. If none are passed, print help and exit.
NUMARGS=$#
echo -e \\n"Number of arguments: $NUMARGS"
if [ $NUMARGS -eq 0 ]; then
	HELP
fi
 
### Start getopts code ###
 
#Parse command line flags
# slient error reporting to  OVERLAPTARG
 
while getopts  :abcd:h  FLAG
do
case $FLAG in
a)  #set option "a"
#OPT_A=$OPTARG
#echo "-a used: $OPTARG"
echo -e "-----------------------------------------------------"
echo -e "Begin to calculate barycenters between HOMO and LUMO "
echo "OPT_A = $OPT_A"
if [ -f ./BARYCENTER_distance.outfile ];  then
	cat  ./BARYCENTER_distance.outfile 
else
	CREAT_HN_CUBE
	CALC_BARYCENTER 
fi 
echo -e "Terminated!"
echo -en "-----------------------------------------------------\n"
;;

b)  #set option "b"
#OPT_B=$OPTARG
#echo "-b used: $OPTARG"
echo -e "-----------------------------------------------------"
echo -e "Begin to calculate modular overlap between HOMO and LUMO "
echo "OPT_B = $OPT_B"
if [ -f  ./OVERLAP_overlap.outfile ];  then
   cat   ./OVERLAP_overlap.outfile
else
   CREAT_HN_CUBE
   CALC_OVERLAP
fi
echo -e "Terminated!"
echo -en "-----------------------------------------------------\n"
;;

c)  #set option "c"
echo -e "-----------------------------------------------------"
echo -e "Begin to calculate spatial overlap (LAMBDA) of an excitation "
echo "OPT_C = $OPT_C"
if [ -f  ./LAMBDA_lambda.outfile ];  then
   cat   ./LAMBDA_lambda.outfile
else
	if [ `ls -l *.log | wc -l` -ne 0 ]; then 
		TREAT_LOG_TDDATA
	fi 
	CREAT_TDDATA_HN_CUBE
	CALC_LAMBDA
fi

echo -e "Terminated!"
echo -en "-----------------------------------------------------\n"
;;

d)  #set option "d"
echo -e "-----------------------------------------------------"
echo -e "Clean tempt files or input files in ./"
OPT_D=$OPTARG
echo "-d used: $OPTARG"
OPT_D_tr=$(echo  ${OPT_D}  |  tr   [a-z]   [A-Z])
OPT_D=${OPT_D_tr}
echo "OPT_D = $OPT_D"
if [ "${OPT_D_tr}" == "CLEAN_ALL" ]; then 
	CLEAN_TMP_FILES
   CLEAN_INPUT_FILES
else 
	CLEAN_TMP_FILES
fi 
echo -e "Terminated!"
echo -en "-----------------------------------------------------\n"
;;

h)  #show help
HELP
;;

\?) #unrecognized option - show help
echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
HELP
# print only short error report 
#echo -e "Use ${BOLD}$SCRIPT -h${NORM} to see the help documentation."\\n
#exit 2
;;
esac
done
 
shift $((OPTIND-1))  #This tells getopts to move on to the next argument.
 
### End getopts code ###
 
 
### Main loop to process files ###
#-----------------------------------------------------------------
 
while [ $# -ne 0 ]; 
do
FILE=$1
TEMPFILE=`basename $FILE`
#TEMPFILE="${FILE##*/}"  
FILE_BASE=`echo "${TEMPFILE%.*}"`  #file without extension
FILE_EXT="${TEMPFILE##*.}"  #file extension
  
echo -e \\n"Additinal file is: $FILE"
echo -e "It's not needed here, and should exist in current dir  ./, "
echo -e "if the extension name is  .fchk.\n"
echo -e "The so-called current dir path is the path where you run the calc_BC_OP_LD.sh " \\n 

cp  ${FILE}  ./ 

echo -e "${FILE} has been copyied to  ./ "
echo -e "Now, you can run this script again without file arguments."
echo -en "Usage:\e[33m ${BOLD}$SCRIPT  -a   -b   -c   -d  CLEAN_ALL  ${NORM} \n" 
#echo "File without extension is: $FILE_BASE"
#echo -e "File extension is: $FILE_EXT"\\n
shift  #Move on to next input file.
done

### End main loop ###

echo -en "\nNormal exit!\n" 

#----------------------------------------------------------
end_time=$(date "+%s")
time=$((end_time-start_time))
echo "-----------------------------------------------------"
echo "time used: $time seconds"


exit 0

#END 
