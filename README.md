docker-cdh3-hadoop
==================

A series of docker containers for Hadoop based on Cloudera CDH3

This packages the Cloudera CDH3 Hadoop distribution into docker containers for easy execution.
You can find the documentation for Cloudera CDH3 at http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH3/CDH3u6/CDH3-Installation-Guide/CDH3-Installation-Guide.html

This is primarily intended to quickly set up a Hadoop cluster; we haven't tested it for long-term use, therefore use it at your own risk.

It consists of these containers:

teco/cdh3-hadoop-base:
The base container, it installs Java 7 and Hadoop, as well as some utilities.
It also includes the conf.docker Hadoop configuration.
When modifying the configuration for your own use, please note that the hostname "hadoopmaster" is used to find the master node and to ensure that Hadoop runs on the right network interface.

teco/cdh3-hadoop-master: 
This command starts the namenode and jobtracker. There must be only one of these per cluster. It automatically formats the HDFS filesystem on startup. If you want to re-up an existing cluster, you first need to use docker commit to save the changes from the last run and then start it with the option --skipFormat

teco/cdh3-hadoop-slave: 
This starts a datanode and a jobtracker. Use as many of these as needed, however due to port forwarding there can be only one instance per machine. Use the --ip= option to point to the jobtracker.

teco/cdh3-hadoop-submit-job: 
This takes a job jar and submits it to the jobtracker. Use the --ip= option to point to the jobtracker and --job to give the internal path to the jar. To make your job available to the container, use the -v to mount your local directory in the container. Any additional arguments are given to the job, however you may need to use quotes to ensure that they don't get parsed by getopt.

teco/cdh3-hadoop-command:
This allows you to use the hadoop commandline interface to administer the hadoop cluster. Use the --ip option to point to the jobtracker.

Use build-all.sh to build and register the containers.

You can find the latest pre-built containers at https://index.docker.io/u/teco/

See also https://github.com/teco-kit/Hadoop-MovementVectorJob/blob/master/test.sh for an example on how to use the docker commands to execute a Hadoop workflow
