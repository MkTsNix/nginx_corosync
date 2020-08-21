#!/bin/bash
# VARS
cluster_name=nginxha
host1=node1
host2=node2
host3=node3
username=hacluster
password=hacluster
# authorize server to create new cluster
echo -e "$username\n$password" | pcs cluster auth node1 node2 node3

# Create cluster and start cluster
pcs cluster setup --name $cluster_name $host1 $host2 $host3
pcs cluster start --all
pcs cluster enable --all

# Disable quorum and stonith
pcs property set stonith-enabled=false
pcs property set no-quorum-policy=ignore

#------ Change or comment this if your want setup other resource

# Create resource for virtul ip and nginx
pcs resource create v_ip ocf:heartbeat:IPaddr2 nic=eth1 ip=192.168.11.90 cidr_netmask=32 op monitor interval=30s
pcs resource create webserver ocf:heartbeat:nginx configfile=/etc/nginx/nginx.conf op monitor timeout="5s" interval="5s"

# Create Constraint
pcs constraint colocation add webserver v_ip INFINITY
pcs constraint order v_ip then webserver

# Restart cluster
pcs cluster stop --all
pcs cluster start --all


