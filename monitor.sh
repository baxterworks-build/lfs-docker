#!/bin/bash
##https://github.com/moby/moby/issues/22618#issuecomment-917369595
echo Name,CPU%,MemUsage,NetIO,BlockIO,PIDs | tee stats.log
while true; do
sleep 4
docker stats --no-stream --format {{.Name}},{{.CPUPerc}},{{.MemUsage}},{{.NetIO}},{{.BlockIO}},{{.PIDs}} | tee -a stats.log
done;
