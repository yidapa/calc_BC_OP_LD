#!/bin/bash

cube_list=`ls *-n.cube `
cube_arr=(${cube_list})

rm -f  *-input-BARYCENTER.dat  *-BARYCENTER.out  2>/dev/null 

count=${#cube_arr[@]}

for i in `seq  1 2  ${count} `
do
    sed -n '4,6 p'   ${cube_arr[$i-1]%-n.cube}-h.cube   | awk '{print $1}'   |  awk  '{print $1 }' >> ${cube_arr[$i-1]%-n.cube}-input-BARYCENTER.dat 
    head  -6  ${cube_arr[$i-1]%-n.cube}-h.cube   | tail -4  | awk '{printf("%13.6f %13.6f %13.6f\n", $2, $3, $4)}'  >> ${cube_arr[$i-1]%-n.cube}-input-BARYCENTER.dat
	 echo "${cube_arr[$i-1]} "  >>  ${cube_arr[$i-1]%-n.cube}-input-BARYCENTER.dat

    sed -n '4,6 p'   ${cube_arr[$i-1]%-n.cube}-h.cube   | awk '{print $1}'   |  awk  '{print $1 }' >> ${cube_arr[$i]%-n.cube}-input-BARYCENTER.dat 
    head  -6  ${cube_arr[$i-1]%-n.cube}-h.cube   | tail -4  | awk '{printf("%13.6f %13.6f %13.6f\n", $2, $3, $4)}'  >> ${cube_arr[$i]%-n.cube}-input-BARYCENTER.dat
    echo "${cube_arr[$i]} "  >>  ${cube_arr[$i]%-n.cube}-input-BARYCENTER.dat
done


# call fortran program  BARYCENTER to calculate barycenter of HOMO LUMO. 
input_dat_list=`ls *-input-BARYCENTER.dat `

for inf_b  in ${input_dat_list}
do
echo "Begin  ${inf_b}"
${CALC_BC_OP_LD_PATH}bin/BARYCENTER   < ${inf_b}   > ${inf_b%-input-BARYCENTER.dat}-BARYCENTER.out 
echo "Finish  ${inf_b}"
done

#end
