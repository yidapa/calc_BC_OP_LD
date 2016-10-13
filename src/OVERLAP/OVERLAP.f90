PROGRAM  OVERLAP
IMPLICIT NONE

!Data dictionary: dec1are constants
INTEGER::  N1    ! the number of voxels along axis x
INTEGER::  N2     ! the number of voxels along axis y
INTEGER::  N3     ! the number of voxels along axis z

! declare  variables 
REAL(kind=8):: X0, Y0, Z0      ! the origin of the grid 
REAL(kind=8):: X1, Y1, Z1      ! unit verctor in quasi x direction 
REAL(kind=8):: X2, Y2, Z2      ! unit verctor in quasi y direction 
REAL(kind=8):: X3, Y3, Z3      ! unit verctor in quasi z direction 

CHARACTER(len=80):: in1_filename, in2_filename    ! the name for the input cube files for MO1, MO2
CHARACTER(len=80):: out_filename    ! the name for output file 

INTEGER:: i, j, k   

REAL(kind=8), ALLOCATABLE, DIMENSION(:, :, :):: MO1_COFF    ! the 3-D array to hold the MO1 coff values 
REAL(kind=8), ALLOCATABLE, DIMENSION(:, :, :):: MO2_COFF    ! the 3-D array to hold the MO2 coff values
!REAL(kind=8), ALLOCATABLE, DIMENSION(:, :, :):: X_COORD     ! the 3-D array to hold the x coord of all points 
!REAL(kind=8), ALLOCATABLE, DIMENSION(:, :, :):: Y_COORD     ! the 3-D array to hold the y coord of all points 
!REAL(kind=8), ALLOCATABLE, DIMENSION(:, :, :):: Z_COORD     ! the 3-D array to hold the z coord of all points 

INTEGER:: status
INTEGER:: I1, I2, I3

!REAL(kind=8):: X_AVE, Y_AVE, Z_AVE 
!REAL(kind=8):: X_MO_SUM2, Y_MO_SUM2, Z_MO_SUM2 
REAL(kind=8):: MODULAR_OVERLAP
REAL(kind=8):: MO1MO2_SUM , MO1MO1_SUM, MO2MO2_SUM  
REAL(kind=8):: temp 

REAL:: start, finish
CALL cpu_time(start)

!**************************main program*************************
!***************************************************************
!--- prompt user to enter the N1, N2, N3 points for x, y, z axies
WRITE(*,'(1X, A)') "Enter the number of voxels along axis x, y and z axies,"
WRITE(*,'(1X, A)') "N1, N2, N3 ="
READ(*, *) N1, N2, N3 

WRITE(*,'(1X, A)') "Enter the origin point, and unit vector"
WRITE(*,'(1X, A)') "X0, Y0, Z0 ="
WRITE(*,'(1X, A)') "X1, Y1, Z1 ="
WRITE(*,'(1X, A)') "X2, Y2, Z2 ="
WRITE(*,'(1X, A)') "X3, Y3, Z3 ="
READ(*, *) X0, Y0, Z0
READ(*, *) X1, Y1, Z1
READ(*, *) X2, Y2, Z2
READ(*, *) X3, Y3, Z3

! print the input parameters to user
WRITE(*,'(1X, A)') "The input parameters for "
WRITE(*,'(1X, A)') "N1, N2, N3 ="
WRITE(*,'(1X, A)') "X0, Y0, Z0 ="
WRITE(*,'(1X, A)') "X1, Y1, Z1 ="
WRITE(*,'(1X, A)') "X2, Y2, Z2 ="
WRITE(*,'(1X, A)') "X3, Y3, Z3 ="
WRITE(*,'(1X, 3I8)')  N1, N2, N3
WRITE(*,'(1X, 3E13.5)') X0, Y0, Z0
WRITE(*,'(1X, 3E13.5)') X1, Y1, Z1
WRITE(*,'(1X, 3E13.5)') X2, Y2, Z2
WRITE(*,'(1X, 3E13.5)') X3, Y3, Z3

!------Allocate arrays------------------------
ALLOCATE ( MO1_COFF(N3, N2, N1) , STAT=status)  
IF (status /= 0 ) THEN
   STOP "Allocate MO1_COFF failed!"
END IF

ALLOCATE ( MO2_COFF(N3, N2, N1) , STAT=status)
IF (status /= 0 ) THEN
   STOP "Allocate MO2_COFF failed!"
END IF

!ALLOCATE ( X_COORD(N3, N2, N1) , STAT=status)
!IF (status /= 0 ) THEN
!   STOP "Allocate X_COORD failed!"
!END IF
!
!ALLOCATE ( Y_COORD(N3, N2, N1) , STAT=status)
!IF (status /= 0 ) THEN
!   STOP "Allocate Y_COORD failed!"
!END IF
!
!ALLOCATE ( Z_COORD(N3, N2, N1) , STAT=status)
!IF (status /= 0 ) THEN
!   STOP "Allocate Z_COORD failed!"
!END IF

!X0= -16.521180; Y0= -12.758327;  Z0= -10.871973  
!X1 = 0.356422 ; Y1=  0.000000;  Z1 =   0.000000 
!X2=  0.000000; Y2= 0.356422 ; Z2=   0.000000  
!X3=  0.000000; Y3=   0.000000; Z3 = 0.356422


MO1MO2_SUM=0.
MODULAR_OVERLAP=0.
MO1MO1_SUM=0.
MO2MO2_SUM=0.
!X_MO_SUM2=0.
!Y_MO_SUM2=0.
!Z_MO_SUM2=0.
!X_AVE=0.
!Y_AVE=0.
!Z_AVE=0.


!-- initialize array elements to 0. 
Do I1=1, N1
      Do  I2=1, N2
         Do  I3=1, N3
            MO1_COFF(I3,I2,I1)= 0.
            MO2_COFF(I3,I2,I1)= 0.
!            X_COORD(I3,I2,I1)= 0.
!            Y_COORD(I3,I2,I1)= 0.
!            Z_COORD(I3,I2,I1)= 0.
         END DO
      END DO
END DO


!----------------------------------------------------------------
WRITE (*, 1000 )
1000 FORMAT (' Enter the file name for MO1: ')
READ (*,' (A80) ') in1_filename

WRITE (*, 1010 )
1010 FORMAT (' Enter the file name for MO2: ')
READ (*,' (A80) ') in2_filename

!Open input data file. Status is OLD because the input data must
!a1ready exist.
OPEN ( UNIT=11 , FILE=in1_filename , STATUS='OLD' , ACTION='READ' , &
IOSTAT=status )
!Was the OPEN successfu1?
fileopen1: IF (status == 0) THEN
!The file was opened successfu11y, so read the data to process.
! read in data for array MO_COFF
Do I1=1, N1
      Do  I2=1, N2
         Read(11,'(6E13.5)', IOSTAT=status) ( MO1_COFF(I3,I2,I1), I3=1,N3 )
      END DO
END DO 

ELSE  fileopen1
!E1se file open fai1ed. Te11 user.
WRITE (*, 1020) status
1020 FORMAT (1X , 'file for MO1 open failed--status ', I6)
END IF fileopen1

CLOSE(UNIT=11)


! open file  for MO2 and read in data 
OPEN ( UNIT=12 , FILE=in2_filename , STATUS='OLD' , ACTION='READ' , &
IOSTAT=status )
!Was the OPEN successful? 
fileopen2: IF (status == 0) THEN
!The file was opened successfu11y, so read the data to process.
! read in data for array MO_COFF
Do I1=1, N1
      Do  I2=1, N2
         Read(12,'(6E13.5)', IOSTAT=status) ( MO2_COFF(I3,I2,I1), I3=1,N3 )
      END DO
END DO

ELSE  fileopen2
!E1se file open fai1ed. Te11 user.
WRITE (*, 1030) status
1030 FORMAT (1X , 'file open failed--status ', I6)
END IF fileopen2

CLOSE(UNIT=12)


!-- calculate the x, y, z coordinates for all grid points
! stored in three respective arrays
!Do I1=1, N1
!      Do  I2=1, N2
!         Do  I3=1, N3
!            X_COORD(I3,I2,I1)= X0+(I1-1)*X1+(I2-1)*X2+(I3-1)*X3
!            Y_COORD(I3,I2,I1)= Y0+(I1-1)*Y1+(I2-1)*Y2+(I3-1)*Y3
!            Z_COORD(I3,I2,I1)= Z0+(I1-1)*Z1+(I2-1)*Z2+(I3-1)*Z3
!         END DO
!      END DO
!END DO


!---------------- Calculated the average values for X,Y,Z weighted by
!---------------- the MO cofficients.
!#################################################################


! calculate the modular_overlap between MO1 and MO2 
Do I1=1, N1
      Do  I2=1, N2
         Do  I3=1, N3
            MO1MO2_SUM= MO1MO2_SUM + DABS( MO1_COFF(I3,I2,I1)*MO2_COFF(I3,I2,I1) )
         END DO
      END DO
END DO
!MO_SUM2= SUM(MO_COFF)

! calculate MO1MO1_SUM, MO2MO2_SUM for check purpose 
Do I1=1, N1
      Do  I2=1, N2
         Do  I3=1, N3
            MO1MO1_SUM= MO1MO1_SUM + MO1_COFF(I3,I2,I1)*MO1_COFF(I3,I2,I1) 
            MO2MO2_SUM= MO2MO2_SUM + MO2_COFF(I3,I2,I1)*MO2_COFF(I3,I2,I1)
         END DO
      END DO
END DO


!Do I1=1, N1
!      Do  I2=1, N2
!         Do  I3=1, N3
!            X_MO_SUM2= X_MO_SUM2 + X_COORD(I3,I2,I1)*MO_COFF(I3,I2,I1)*MO_COFF(I3,I2,I1)
!            Y_MO_SUM2= Y_MO_SUM2 + Y_COORD(I3,I2,I1)*MO_COFF(I3,I2,I1)*MO_COFF(I3,I2,I1)
!            Z_MO_SUM2= Z_MO_SUM2 + Z_COORD(I3,I2,I1)*MO_COFF(I3,I2,I1)*MO_COFF(I3,I2,I1)
!         END DO
!      END DO
!END DO

!X_AVE= X_MO_SUM2/MO_SUM2
!Y_AVE= Y_MO_SUM2/MO_SUM2
!Z_AVE= Z_MO_SUM2/MO_SUM2

MODULAR_OVERLAP=MO1MO2_SUM 

!#################################################################

!-------------------------------------------------------------------
!Te11 user.  For check purpose  
!WRITE(*, '(1X,A)') "#--------------------------------------------"
!WRITE(*, '(1X,A)') "# MO1_COFF is:"
!
!Do I1=1, N1
!      Do  I2=1, N2
!         WRITE(*,'(6E13.5)') ( MO1_COFF(I3,I2,I1), I3=1,N3 )
!      END DO
!END DO
!
!WRITE(*, '(1X,A)') "#--------------------------------------------"
!WRITE(*, '(1X,A)') "# MO2_COFF is:"
!
!Do I1=1, N1
!      Do  I2=1, N2
!         WRITE(*,'(6E13.5)') ( MO2_COFF(I3,I2,I1), I3=1,N3 )
!      END DO
!END DO


!WRITE(*, '(1X,A)') "#--------------------------------------------"
!WRITE(*, '(1X,A)') "# X_COORD is:"
!
!Do I1=1, N1
!      Do  I2=1, N2
!         WRITE(*,'(6E13.5)') ( X_COORD(I3,I2,I1), I3=1,N3 )
!      END DO
!END DO
!
!WRITE(*,'(1X,A)') "#--------------------------------------------"
!WRITE(*,'(1X,A)') "# Y_COORD is:"
!
!Do I1=1, N1
!      Do  I2=1, N2
!         WRITE(*,'(6E13.5)') ( Y_COORD(I3,I2,I1), I3=1,N3 )
!      END DO
!END DO
!
!WRITE(*,'(1X,A)') "#--------------------------------------------"
!WRITE(*,'(1X,A)') "# Z_COORD is:"
!
!Do I1=1, N1
!      Do  I2=1, N2
!         WRITE(*,'(6E13.5)') ( Z_COORD(I3,I2,I1), I3=1,N3 )
!      END DO
!END DO

WRITE(*,'(1X,A)') "---------------------------------------------------------"
WRITE(*,'(1X,A)') "############### FINAL SUMMARY OF BARYCENTER #############"
WRITE(*,'(1X,A)') "#--------------------------------------------------------"
WRITE(*,'(1X, A)') "The input parameters for "
WRITE(*,'(1X, A20, 3I8)')  "N1, N2, N3 = ",  N1, N2, N3
WRITE(*,'(1X, A20, 3E13.5)') "X0, Y0, Z0 =", X0, Y0, Z0 
WRITE(*,'(1X, A20, 3E13.5)') "X1, Y1, Z1 =", X1, Y1, Z1
WRITE(*,'(1X, A20, 3E13.5)') "X2, Y2, Z2 =", X2, Y2, Z2
WRITE(*,'(1X, A20, 3E13.5)') "X3, Y3, Z3 =", X3, Y3, Z3
WRITE(*,'(1X, A)' ) "" 
!WRITE(*,'(1X,A20, E13.5)') "# MO_SUM2    = ", MO_SUM2
!WRITE(*,'(1X,A20, E13.5)') "# X_MO_SUM2  = ", X_MO_SUM2
!WRITE(*,'(1X,A20, E13.5)') "# Y_MO_SUM2  = ", Y_MO_SUM2
!WRITE(*,'(1X,A20, E13.5)') "# Z_MO_SUM2  = ", Z_MO_SUM2
!WRITE(*,'(1X,A, E13.5)') "# MO_SUM2 * X1 * Y2 * Z3 = ", MO_SUM2*X1*Y2*Z3
!WRITE(*,'(1X,A20, E13.5)') "# X_AVE     = ", X_AVE
!WRITE(*,'(1X,A20, E13.5)') "# Y_AVE     = ", Y_AVE
!WRITE(*,'(1X,A20, E13.5)') "# Z_AVE     = ", Z_AVE
WRITE(*,'(1X,A20, E13.5)') "# MO1MO1_SUM    = ", MO1MO1_SUM
WRITE(*,'(1X,A, E13.5)') "# MO1MO1_SUM * X1 * Y2 * Z3 = ", MO1MO1_SUM*X1*Y2*Z3
WRITE(*,'(1X,A20, E13.5)') "# MO2MO2_SUM    = ", MO2MO2_SUM
WRITE(*,'(1X,A, E13.5)') "# MO2MO2_SUM * X1 * Y2 * Z3 = ", MO2MO2_SUM*X1*Y2*Z3
WRITE(*,'(1X,A20, E13.5)') "# MO1MO2_SUM    = ", MO1MO2_SUM
WRITE(*,'(1X,A20, E13.5)') "# MODULAR_OVERLAP    = ", MODULAR_OVERLAP
WRITE(*,'(1X,A, E13.5)') "# MODULAR_OVERLAP * X1 * Y2 * Z3 = ", MODULAR_OVERLAP*X1*Y2*Z3
WRITE(*,'(1X,A, E13.5)') "# FINAL RESULT = ", MODULAR_OVERLAP*X1*Y2*Z3 

!-----Deallocate arrays-------------------------
DEALLOCATE ( MO1_COFF, STAT=status )
DEALLOCATE ( MO2_COFF, STAT=status )
!DEALLOCATE ( X_COORD, STAT=status )
!DEALLOCATE ( Y_COORD, STAT=status )
!DEALLOCATE ( Z_COORD, STAT=status )

! put code to test here
CALL cpu_time(finish)

WRITE (*, '(1X,A)') "#-----------------------------------------------"
WRITE (*, 2000)  finish - start
2000  FORMAT (1X, 'Time = ', f6.3," seconds.") 

STOP
END PROGRAM  OVERLAP
