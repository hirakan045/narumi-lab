################## INPUT PARAMETER ####################################
seasons = ['01'] #'04','05','06','07','08','09','10','11','12','01','02','03',
case = 'base' #対策なし：'base', 高反射：'alb', 屋上緑化：'gr' 屋上散水：'wr'
path='/home/narumi/WRF/DATA/hirayama/' 
#######################################################################

import os

input_namelist = "namelist.input"
input_urban = "URBPARM_LCZ.TBL"

for season in seasons:
	os.system('ln -sf ' + path + 'WPS/' + season +'/met_em* .')
	with open(path + 'namelist/' + season) as f:
		s1_new = f.read()
	with open(input_namelist, "w") as f:
		f.write(s1_new)
	with open(path + 'urban/' + case + '_' + season) as f:
		s2_new = f.read()
	with open(input_urban,"w") as f:
		f.write(s2_new)
	os.system('./real.exe')
	os.system('mpirun -np 10 ./wrf.exe')
	os.system('mv wrfout_d03* ' + path + 'wrfout/' + case)
	os.system('rm met_em*')
	os.system('rm wrfbdy_d01')
	os.system('rm wrfinput*')
	os.system('rm wrfrst*')
	os.system('rm wrfout*')

