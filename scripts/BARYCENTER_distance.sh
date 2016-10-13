#!/bin/bash -f

fchk_files=`ls *.fchk `
BARYCENTER_out_files=`ls  *-BARYCENTER.out `
output_file="BARYCENTER_distance.outfile"

cat /dev/null >  ${output_file}

rm  -f  *.temp  2>/dev/null  

echo "Begin *****************************************"

grep -i "# X_AVE" -A2   *-BARYCENTER.out   >  BARYCENTER_out.temp 

for  inf  in  ${BARYCENTER_out_files}
do
   cat  BARYCENTER_out.temp    |  grep -i "# X_AVE"  |  sed -n '1~2 p' | awk '{print $NF}' > X_H.temp 
   cat  BARYCENTER_out.temp    |  grep -i "# X_AVE"  |  sed -n '2~2 p' | awk '{print $NF}' > X_L.temp
   cat  BARYCENTER_out.temp    |  grep -i "# Y_AVE"  |  sed -n '1~2 p' | awk '{print $NF}' > Y_H.temp
   cat  BARYCENTER_out.temp    |  grep -i "# Y_AVE"  |  sed -n '2~2 p' | awk '{print $NF}' > Y_L.temp
   cat  BARYCENTER_out.temp    |  grep -i "# Z_AVE"  |  sed -n '1~2 p' | awk '{print $NF}' > Z_H.temp
   cat  BARYCENTER_out.temp    |  grep -i "# Z_AVE"  |  sed -n '2~2 p' | awk '{print $NF}' > Z_L.temp
done

paste   X_H.temp  X_L.temp  Y_H.temp  Y_L.temp  Z_H.temp  Z_L.temp  >  XYZ_HL.temp 

echo "${fchk_files}"  >  Compounds.temp 

paste  Compounds.temp   XYZ_HL.temp   >  Compounds_XYZ_HL.temp 

cat  Compounds_XYZ_HL.temp |  awk '{printf("%-40s %13.6e %13.6e %13.6e %13.6e %13.6e %13.6e\n", $1, $2, $3, $4, $5, $6, $7 )}' >>  ${output_file} 

echo "----------------------------------------------------------------------"  >> ${output_file} 
echo "----------Compound--------------------------Distance------------------"  >> ${output_file}

cat Compounds_XYZ_HL.temp  |  awk '{printf("%-40s %13.6f\n", $1, sqrt( ($3-$2)*($3-$2) + ($5-$4)*($5-$4)+ ($7-$6)*($7-$6) )  )}'  

cat Compounds_XYZ_HL.temp  |  awk '{printf("%-40s %13.6f\n", $1, sqrt( ($3-$2)*($3-$2) + ($5-$4)*($5-$4)+ ($7-$6)*($7-$6) )  )}'  >>  ${output_file} 

rm -f  *.temp  2>/dev/null  

echo "Finished! **************************************"

#END 
