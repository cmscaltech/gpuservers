import os
import sys
import time
import json
import socket
from collections import defaultdict

def get_percent():
    return [int(l.split()[12].replace('%','')) for l in os.popen('nvidia-smi  | grep Defaul').read().split('\n') if l]
    
def get_processes():
    collect=False
    pids = defaultdict(set)
    for l in os.popen('nvidia-smi').read().split('\n'):
        if collect:
            l_s = l.split()
            if len(l_s) == 7:
                pids[l_s[1]].add( l_s[2] )
        if l.split() == '| GPU       PID   Type   Process name                             Usage  |'.split():
            collect = True
    return pids

ntimes = int(sys.argv[1]) if len(sys.argv)>1 else None
host = socket.gethostname()
every = 60 # seconds
check_point_every = 5*60 # seconds
time_check_point=None
process_timeout = 60*60 # seconds
purge = process_timeout * 1.2
record_file = '/storage/group/gpu/software/gpu-util-{}.json'.format(host)
record = {}
if os.path.isfile( record_file):
    record.update( dict([(int(float(k)),v) for (k,v) in json.loads( open(record_file).read()).items()]))
    time_check_point = max(record.keys())

times=1
while True:
    now = time.mktime(time.localtime())
    util = get_percent()
    record[now] = dict([(str(g),v) for (g,v) in enumerate(util)])

    if time_check_point == None or (now-time_check_point) > check_point_every:
        time_check_point = now
        #purge 7 days old
        record = dict([(k,v) for (k,v) in record.items() if (k-now) < purge])
        print ('Writing record to {}'.format(record_file))
        open(record_file,'w').write( json.dumps( record ))
        
    if (now - min(record.keys())) > process_timeout:
        print ('enough time has passed, can check on process utilization')
        pids = get_processes()
        ## for each GPU, average utilization over the last N hours
        for gpu in pids.keys():
            gpu_record = [v[str(gpu)] for (k,v) in record.items() if (k-now) < process_timeout]
            mean_util = sum(gpu_record) / float(len(gpu_record))

            if mean_util <= 0:
                print ('processes on gpu {} are not using it. Mean utilization {}%'.format( gpu, mean_util ))
                for pid in pids[gpu]:
                    print ("Killing {}".format(pid))
                    os.system('kill -9 {}'.format(pid))
    if ntimes and times>=ntimes: break
    times+=1
    time.sleep( every )
