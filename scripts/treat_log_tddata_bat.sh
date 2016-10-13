#!/bin/bash

# set basic vriables  
SCRIPT=`basename ${BASH_SOURCE[0]}` 

# function HELP 
function HELP {
echo -e  "This script can grep CI coefficients of an electron excitation from .log file."
echo -e  "It greps the lines between 'Excited State   1' and 'This state for optimization' " 
echo -e  "If the contents nonempty, after appropriate substitution, the data will be stored "
echo -e  "in file .tddata with the same basename of the .log file"
echo -e  "Usage: ./${SCRIPT} "
echo -e  "run it in a menu containing .log files from TD or CIS jobs. "\\n
exit 1
}

#------------------------------------------------------------------
log_name_list=`ls  *.log `
number_logs=`ls -l *.log | wc -l `

if [ ${number_logs} -eq 0 ]; then 
	HELP
fi 

echo -e  'Begin treating .log for .tddata *********************************'

for log_name in  ${log_name_list}
do 
	output_name=${log_name%.log}.tddata 
	tddata_string=`sed  -n  -e  "/[[:space:]]*Excited State   1:[[:space:]]*/,/[[:space:]]*This state for optimization/ p"    ${log_name}   |  head -n -1 |  sed -n  '1 !p'  `

	if [ "${tddata_string}" == "" ]; then 
		echo -e "The contents of CI coefficents in ${log_name} is empty, please check it"
		exit 1
	else 
		echo -e "${tddata_string}" |  sed  -n  's/[-<][->]/  /gp'   >  ${output_name}
		echo -e "The CI coefficients of 'Excited State 1' in ${log_name} "
		echo -e "have been written to ${output_name}"
	fi 

done

echo -e 'Finish treatment ************************************************' 

#END
