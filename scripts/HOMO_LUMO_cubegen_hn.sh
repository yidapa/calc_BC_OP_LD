#!/bin/bash -f

start_time=$(date "+%s") 

fchk_files=`ls *.fchk `
output_file="HOMO_LUMO_cubegen_hn.out"
cat /dev/null >  ${output_file}

#rm -f  *-[hn].cube 2&>/dev/null 

if [ ${#fchk_files} -eq 0 ]; then
	echo -e "Servere ERROR."
	echo -e "No fchk file exist!"
	echo -e "Please copy fchk files to  ./tmp/, and retry"
	exit 1
fi 

#--------------creat h-cube -------------------------------
for  inf  in  ${fchk_files}
do
No_HOMO=`grep  -i  "alpha electrons"  ${inf}    | uniq  | awk '{print $NF}' `
No_LUMO=$((No_HOMO + 1))

echo "-----------------------------------------
     ${inf}
     No_HOMO=${No_HOMO},  No_LUMO=${No_LUMO} " >> ${output_file} 
echo -e "-----------------------------------------------------"
echo -e "creat ${inf%.fchk}-${No_HOMO}-h.cube "
cubegen  8  MO=HOMO    ${inf}   ${inf%.fchk}-${No_HOMO}-h.cube  80  h 
#cubegen  8  MO=HOMO    ${inf}   ${inf%.fchk}-${No_HOMO}-n.cube  80  n

echo -e "-----------------------------------------------------"
echo -e "${inf%.fchk}-${No_LUMO}-n.cube "
cubegen  8  MO=LUMO    ${inf}   ${inf%.fchk}-${No_LUMO}-n.cube  80  n
#cubegen  8  MO=LUMO    ${inf}   ${inf%.fchk}-${No_LUMO}-n.cube  80  n
#cubegen  8  MO=${No_LUMO}    ${inf}   ${inf%.fchk}-${No_LUMO}.cube

done


#--------------creat n-cube from h-cube---------------------
h_cube_list=`ls  *-h.cube ` 

for inf_b in ${h_cube_list}
do
cut_line=`sed  -n  '3 p' ${inf_b} | awk '{print -$1+7 }' `

cp     ${inf_b}   ${inf_b%-h.cube}-n.cube
sed -i "1, ${cut_line} d"   ${inf_b%-h.cube}-n.cube 

done


#----------------------------------------------------------
end_time=$(date "+%s")
time=$((end_time-start_time))
echo "-----------------------------------------------------" >> ${output_file} 
echo "time used: $time seconds"  >> ${output_file}
echo "-----------------------------------------------------"
echo "time used: $time seconds" 

#END
