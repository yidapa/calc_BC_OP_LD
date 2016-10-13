#!/bin/bash -f

start_time=$(date "+%s") 

fchk_files=`ls *.fchk `
tddata_files=`ls *.tddata `
output_file="tddata_MOs_cubegen_hn.out"
cat /dev/null >  ${output_file}

#rm -f  *-[hn].cube  *-HOMO.cube  2&>/dev/null 

fchk_files_arr=(${fchk_files})
tddata_files_arr=(${tddata_files})

if [ ${#fchk_files_arr[@]} -eq 0 ]; then
	echo -e "# Servere ERROR."
	echo -e "No fchk file exist!"
	echo -e "Please copy fchk files to  ./tmp/, and retry"
	exit 1
fi 

if [ ${#tddata_files_arr[@]} -eq 0 ]; then
   echo -e "# Servere ERROR."
   echo -e "No tadata file exist!"
   echo -e "Please copy fchk files to  ./tmp/, and retry"
	echo -e "Typically, .tadata files will be created automatically if .log files are provided."
   exit 1
fi

echo '${#fchk_files_arr[@]} = '  " ${#fchk_files_arr[@]}"
echo '${#tddata_files_arr[@] = ' " ${#tddata_files_arr[@]}"

if [ ${#fchk_files_arr[@]} -ne ${#tddata_files_arr[@]} ]; then
	echo -e "# Servere ERROR."
	echo -e "number of .fchk files not equal that of .tddata files, check it."
	exit 1
fi




#--creat HOMO h-cube for all .fchk ------------------------
for inf in ${fchk_files}
do
	HOMO="HOMO" 
	if [ ! -f ./${inf%.fchk}-${HOMO}-h.cube ]; then 
		echo "------------------------------------------------"
		echo "creat ${inf%.fchk}-${HOMO}-h.cube "
		cubegen  8  MO=${HOMO}    ${inf}   ${inf%.fchk}-${HOMO}-h.cube  80  h
	fi 
done 

#--------------creat n-cube -------------------------------
for  inf  in  ${fchk_files}
do
	Ocuppied_MO_list=`cat ${inf%.fchk}.tddata  | awk '{print $1}' |  sort  -n -k 1  | uniq  `
	Vitual_MO_list=`cat ${inf%.fchk}.tddata   | awk '{print $2}' |  sort  -n -k 1  | uniq   `
	MO_lists=`  echo  ${Ocuppied_MO_list}  ${Vitual_MO_list}  `

   echo -e "Ocuppied_MO_list="
	echo -e "${Ocuppied_MO_list}" 
   echo -e "Vitual_MO_list="
	echo "${Vitual_MO_list} "
   echo -e "MO_list="
	echo "${MO_lists} " 
	
	for inf_a  in ${MO_lists} 
	do 
		echo "-----------------------------------------
		     ${inf}
		     MO=${inf_a} " >> ${output_file} 
		if [ ! -f  ./${inf%.fchk}-${inf_a}-n.cube ]; then 
			echo "------------------------------------------------"
	      echo "creat ${inf%.fchk}-${inf_a}-n.cube "	
			cubegen  8  MO=${inf_a}    ${inf}   ${inf%.fchk}-${inf_a}-n.cube  80  n
		fi 
	done 

done


#----------------------------------------------------------
end_time=$(date "+%s")
time=$((end_time-start_time))
echo "-----------------------------------------------------" >> ${output_file} 
echo "time used: $time seconds"  >> ${output_file}
echo "-----------------------------------------------------"
echo "time used: $time seconds" 

#END
