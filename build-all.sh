#!/bin/sh

cd cdh3-base
sudo docker build -t teco/cdh3-hadoop-base .
cd ../cdh3-master
sudo docker build -t teco/cdh3-hadoop-master .
cd ../cdh3-slave
sudo docker build -t teco/cdh3-hadoop-slave .
cd ../cdh3-submit-job
sudo docker build -t teco/cdh3-hadoop-submit-job .
cd ../cdh3-command
sudo docker build -t teco/cdh3-hadoop-command .