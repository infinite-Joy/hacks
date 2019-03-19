# Airflow setup

## Steps:

1. 

	export LOCAL_IP4=`ipconfig getifaddr en0 || ipconfig getifaddr eth0` # this is for mac. for ubuntu and others you will need hostname -I

	➜  airflow-setup echo $LOCAL_IP4
	192.168.0.102
