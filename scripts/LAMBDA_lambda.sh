#!/bin/bash -f

start_time=$(date "+%s")

output_file="LAMBDA_lambda.outfile"

cat /dev/null >  ${output_file}

rm  -f  *.temp  2>/dev/null  

echo "Begin *****************************************"

fchk_files=`ls *.fchk `

for inf_a in ${fchk_files}
do 
LAMBDA_out_files=`ls -l  *-LAMBDA.out | grep "${inf_a%.fchk}" | awk '{print $NF }' `

grep "# FINAL RESULT"   ${LAMBDA_out_files}   | awk '{print $1,  $NF }'  >  ${inf_a%.fchk}-LAMBDA.out   

cat  ${inf_a%.fchk}.tddata | awk '{print  $1"-"$2"-"NR, $3 }' | sort  > ${inf_a%.fchk}.tddata.temp 
echo "# ${inf_a} : ${inf_a%.fchk}.tddata "
echo "# the sum_C2, sum_C2L, Lambda are:"
paste   ${inf_a%.fchk}-LAMBDA.out   ${inf_a%.fchk}.tddata.temp    | awk -v sum_C2L=0. -v sum_C2=0.  -v Lambda=0.  '{ sum_C2=sum_C2 + $4*$4 ; sum_C2L=sum_C2L + $4*$4*$2 } END { Lambda=sum_C2L/sum_C2 ;  print  sum_C2, sum_C2L, Lambda; print "# Lambda= ",  Lambda }'  

# append this compound, Lambda, and CI cofficients  to output file for check purpose 
paste   ${inf_a%.fchk}-LAMBDA.out   ${inf_a%.fchk}.tddata.temp   >>  ${output_file} 

echo "# ${inf_a} : ${inf_a%.fchk}.tddata "  >> LAMBDA_out.temp 
echo "# the sum_C2, sum_C2L, Lambda are:"  >> LAMBDA_out.temp 
paste   ${inf_a%.fchk}-LAMBDA.out   ${inf_a%.fchk}.tddata.temp      | awk -v sum_C2L=0. -v sum_C2=0.  -v Lambda=0.  '{ sum_C2=sum_C2 + $4*$4 ; sum_C2L=sum_C2L + $4*$4*$2 } END { Lambda=sum_C2L/sum_C2 ; print  sum_C2, sum_C2L, Lambda; print "# Lambda= ",  Lambda }'  >> LAMBDA_out.temp
done 

echo "${fchk_files}"  >  Compounds.temp 
grep "# Lambda= "  LAMBDA_out.temp  | awk '{print $NF}'   > LAMBDA_out1.temp

paste   Compounds.temp   LAMBDA_out1.temp   |     awk '{printf("%-40s %13.6f\n", $1, $2 )}'   >  Compounds_lambda.out 

echo "----------------------------------------------------------------------"  >> ${output_file}
echo "----------Compound-----------------LAMBDA--------------------"  >> ${output_file}
#cat  Compounds_lambda.temp  |  awk '{printf("%-40s %13.6f\n", $1, $2 )}' >>  ${output_file} 
cat  Compounds_lambda.out    >> ${output_file} 

echo "----------------------------------------------------------------------" 
echo "----------Compound-----------------LAMBDA--------------------" 
#cat  Compounds_lambda.temp  |  awk '{printf("%-40s %13.6f\n", $1, $2 )}' >>  ${output_file} 
cat  Compounds_lambda.out  

rm -f  *.temp  2>/dev/null  

echo "Finished! **************************************"

#----------------------------------------------------------
end_time=$(date "+%s")
time=$((end_time-start_time))
echo "-----------------------------------------------------"
echo "time used: $time seconds" 

#END 
