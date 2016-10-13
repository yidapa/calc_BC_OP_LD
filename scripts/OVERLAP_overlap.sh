#!/bin/bash -f

start_time=$(date "+%s")

fchk_files=`ls *.fchk `
OVERLAP_out_files=`ls  *-OVERLAP.out `
output_file="OVERLAP_overlap.outfile"

cat /dev/null >  ${output_file}

rm  -f  *.temp  2>/dev/null  

echo "Begin *****************************************"

grep -i "# FINAL RESULT"   *-OVERLAP.out  |  awk '{print $NF}'   >  OVERLAP_out.temp 


echo "${fchk_files}"  >  Compounds.temp 

paste  Compounds.temp   OVERLAP_out.temp   >  Compounds_overlap.temp 

echo "----------------------------------------------------------------------"  >> ${output_file}
echo "----------Compound-----------------Modular overlap--------------------"  >> ${output_file}
cat  Compounds_overlap.temp  |  awk '{printf("%-40s %13.6f\n", $1, $2 )}' >>  ${output_file} 


rm -f  *.temp  2>/dev/null  

echo "Finished! **************************************"

#----------------------------------------------------------
end_time=$(date "+%s")
time=$((end_time-start_time))
echo "-----------------------------------------------------"
echo "time used: $time seconds" 

#END 
