import re
import os
import datetime
import numpy as np
import pandas as pd


###############   INPUT PARAMETER   #################
seasons = ['04','05','06','07','08','09','10','11','12', '01', '02', '03']
case = 'gr' #対策なし：'base', 高反射：'alb', 屋上緑化：'gr' 屋上散水：'wr'
#####################################################

start = str(2015040100)
end = str(2016033123)
wrfouts = {'04':'wrfout_d03_2015-03-29_00:00:00', '05':'wrfout_d03_2015-04-28_00:00:00',\
           '06':'wrfout_d03_2015-05-29_00:00:00', '07':'wrfout_d03_2015-06-28_00:00:00',\
           '08':'wrfout_d03_2015-07-29_00:00:00', '09':'wrfout_d03_2015-08-29_00:00:00',\
           '10':'wrfout_d03_2015-09-28_00:00:00', '11':'wrfout_d03_2015-10-29_00:00:00',\
           '12':'wrfout_d03_2015-11-28_00:00:00', '01':'wrfout_d03_2015-12-29_00:00:00',\
           '02':'wrfout_d03_2016-01-29_00:00:00', '03':'wrfout_d03_2016-02-27_00:00:00'}

# 1month, col=29days:769, 30days:793, 31days:817  *add 1 to time
row = 8100
col = {'04':793, '05':817, '06':793, '07':817, '08':817, '09':793,\
       '10':817, '11':793, '12':817, '01':817, '02':769, '03':817}

# define path
path = '/home/narumi/WRF/DATA/kanji/wrfout/wrfout_' + case + '/'

# output for text_file
for season in seasons:
    os.system('ncdump -v T2 ' + path + wrfouts[season] + \
    ' > ' + path + 'T2_' + case + '_' + season + '.txt')


# define try function
def is_float(s):
    try:
        float(s)
    except:
        return False
    return True


# arrange text_file
for season in seasons:
    with open(path + 'T2_' + case + '_' + season + '.txt') as f:
        s = f.read().split('\n')
    s = s[1343:]
    s = '\n'.join(s)
    s = re.split('[\n\t\r ,]+', s)
    s = list(filter(is_float, s))
    print(s[:10])
    tot = row * col[season]
    if len(s) != tot:
        print('expected', tot, 'acutual', len(s))
        exit()

    s = '\n'.join(', '.join(s[i:i+row]) for i in range(0, tot, row))

    with open(path + 'T2_' + case + '_' + season + '.txt', 'w') as f:
        f.write(s)


# concatenate T2
T = []
for season in seasons:
    t = np.loadtxt(path + 'T2_' + case + '_' + season + '.txt', delimiter=',')
    t = t[63:-10]
    if season == seasons[0]:
        T = t
    else:
        T = np.concatenate([T,t])


# create datetime
start_dt = datetime.datetime.strptime(start, '%Y%m%d%H')
end_dt = datetime.datetime.strptime(end, '%Y%m%d%H')

datetime_list = []
t = start_dt
while t <= end_dt:
    datetime_list.append(t)
    t += datetime.timedelta(hours=1)


# create index(WRF_ID) and columns(datetime)
T = T.T
T = pd.DataFrame(data=T,index=[str(i) for i in range(1,8101)])
T.index.name = "WRF_ID"
T.columns = datetime_list


# output for csv_file
T = T - 273.15
T.to_csv(path + 'T2_' + case + '.csv', float_format='%.2f')
