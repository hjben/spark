docker exec master start-master.sh
docker exec master /bin/bash -c "start-slave.sh spark://master:7077 -c 4 -m 8G"
docker exec slave1 /bin/bash -c "start-slave.sh spark://master:7077 -c 4 -m 8G"
docker exec slave2 /bin/bash -c "start-slave.sh spark://master:7077 -c 4 -m 8G"
