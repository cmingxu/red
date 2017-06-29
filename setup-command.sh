# zookeeper

docker run --name zookeeper -p 2181:2181 --restart always -d zookeeper

# mesos-master
/root/mesos/mesos/build/bin/mesos-master.sh --zk=zk://114.55.130.152:2181/mesos --ip=114.55.130.152 --hostname=114.55.130.152 --cluster=aliyun --work_dir=/var/lib/mesos --quorum=1

# mesos-agent
 ./mesos/mesos/build/bin/mesos-agent.sh --containerizers=mesos,docker --master=zk://114.55.130.152:2181/mesos --ip=114.55.130.152 --hostname=114.55.130.152 --attributes=vcluster:foobar --work_dir=/var/lib/mesos/agent

# marathon
./bin/start --master zk://114.55.130.152:2181/mesos --zk zk://114.55.130.152:2181/marathon1 --event_subscriber http_callback



# bamboo
 docker run -t -i --rm --network=host  -e MARATHON_ENDPOINT=http://114.55.130.152:8080   -e MARATHON_USER=foobar -e MARATHON_PASSWORD=abcdef -e BAMBOO_ENDPOINT=http://114.55.130.152:8001     -e BAOO_ZK_HOST=114.55.130.152:2181     -e BAMBOO_ZK_PATH=/bamboo     -e BIND=":8001"     -e CONFIG_PATH="config/production.example.json"     -e BAMBOO_DOCKER_AUTO_HOST=true bamboo
