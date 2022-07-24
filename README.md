## Infrastructure workshop

**Goal:**

This repo has a group assignment project. 

The assignment consists in creating a terraform and ansible code to deploy an instance and install the Prometheus stack on it. 
The instance type should be "Standard_D4_v3". The Prometheus instance should be able to connect to the instance with an public IP and gather its node exporter metrics, presenting them in a Grafana dashboard. 

**How it was deployed:**

Two folders were created and inside the respective code. Nothing was excluded, meaning, no .gitgnore file was created. 
Terraform – This folder has all the code to deploy an Azure Virtual machine.  
Ansible – This folder has all the code to install configure Prometheus, Alert Manager and Grafana in the previously created Azure Virtual Machine. 

**How to run terraforms**
(resuing the plan file) terrafom apply plan

**How to run ansible**
ansible-playbook configure_prometheus_stack.yaml --inventory ../inventory/hosts