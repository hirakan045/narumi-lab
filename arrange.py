##########################################################
#入力ファイル（txt)
input_file = '/home/narumi/WRF/Python/test.txt'
#出力ファイル(csv)
output_file = '/home/narumi/WRF/Python/test.csv'

#行数
row = 8100
#列数
col = 811 #1month = 29:787, 30:811, 31:835
##########################################################

import re

def is_float(s):
    try:
        float(s)
    except:
        return False
    return True

with open(input_file) as f:
    s = f.read()

s = re.split('[\n\t\r ,]+', s)
s = list(filter(is_float, s))


tot = row * col

if len(s) != tot:
    print('expected', tot, 'acutual', len(s))
    exit()

s = '\n'.join(', '.join(s[i:i+row]) for i in range(0, tot, row))

with open(output_file, 'w') as f:
    f.write(s)
