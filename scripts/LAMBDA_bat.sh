#!/bin/bash

fchk_list=`ls *.fchk `
cube_arr=(${cube_list})

rm -f  *-input-LAMBDA.dat  *-LAMBDA.out  2>/dev/null 

for inf_a in ${fchk_list}
do
	Occupied_list=` cat  ${inf_a%.fchk}.tddata  | awk '{print $1}'  `
	Vitual_list=` cat  ${inf_a%.fchk}.tddata  | awk '{print $2}'  `
	Occupied_arr=(${Occupied_list})
	Vitual_arr=(${Vitual_list})
	count=${#Occupied_arr[@]}
	
	for i in `seq 1 ${count} `
	do
	 	sed -n '4,6 p'  ${inf_a%.fchk}-HOMO-h.cube  | awk '{print $1}'   |  awk  '{print $1 }' >> ${inf_a%.fchk}-${Occupied_arr[$i-1]}-${Vitual_arr[$i-1]}-$i-input-LAMBDA.dat 
	    head  -6  ${inf_a%.fchk}-HOMO-h.cube   | tail -4  | awk '{printf("%13.6f %13.6f %13.6f\n", $2, $3, $4)}'  >> ${inf_a%.fchk}-${Occupied_arr[$i-1]}-${Vitual_arr[$i-1]}-$i-input-LAMBDA.dat 
	    echo "${inf_a%.fchk}-${Occupied_arr[$i-1]}-n.cube"  >>  ${inf_a%.fchk}-${Occupied_arr[$i-1]}-${Vitual_arr[$i-1]}-$i-input-LAMBDA.dat 
	    echo "${inf_a%.fchk}-${Vitual_arr[$i-1]}-n.cube"  >>  ${inf_a%.fchk}-${Occupied_arr[$i-1]}-${Vitual_arr[$i-1]}-$i-input-LAMBDA.dat 
	done 

done 


# call fortran program  LAMBDA  to calculate overlap between a pair of MOs. 
input_dat_list=`ls *-input-LAMBDA.dat `

for inf_b  in ${input_dat_list}
do
echo "----------------------------------------------------"
echo "Begin  ${inf_b}"
${CALC_BC_OP_LD_PATH}bin/OVERLAP   < ${inf_b}   > ${inf_b%-input-LAMBDA.dat}-LAMBDA.out 
echo "Finish  ${inf_b}"
done

#end
