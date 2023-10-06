
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Host Out of Memory (OOM) Incident
---

The Host Out of Memory (OOM) Incident occurs when a server or system runs out of memory, causing it to crash or become unresponsive. This can be caused by various factors, such as an unexpected surge in traffic or insufficient resources allocated to the system. Resolving this type of incident requires identifying the root cause of the memory issue and taking appropriate measures such as optimizing system resources or increasing memory capacity.

### Parameters
```shell
export PROCESS_NAME="PLACEHOLDER"

export SERVICE_NAME="PLACEHOLDER"

export INSTANCE_ID="PLACEHOLDER"

export INSTANCE_TYPE="PLACEHOLDER"

export ZONE="PLACEHOLDER"

export RESOURCE_GROUP_NAME="PLACEHOLDER"
```

## Debug

### Check the amount of free memory
```shell
Get-WmiObject -Class Win32_OperatingSystem | Select-Object FreePhysicalMemory
```

### Check the amount of used memory by each process
```shell
Get-Process | Sort-Object -Descending WS | Select-Object ProcessName, WS -First 10
```

### Check the event viewer logs for any out of memory errors
```shell
Get-EventLog System -Source Microsoft-Windows-Resource-Exhaustion-Detector | Where-Object {$_.EventID -eq 2004}
```

### Check the system limits for the amount of memory available
```shell
Get-WmiObject -Class Win32_ComputerSystem | Select-Object TotalPhysicalMemory
```

### Check the page file usage on the host
```shell
Get-WmiObject -Class Win32_PageFileUsage | Select-Object Name, AllocatedBaseSize, CurrentUsage, PeakUsage
```

### Check the process limits for the user running the process
```shell
Get-Process | Where-Object {$_.ProcessName -eq "${PROCESS_NAME}"} | Select-Object -ExpandProperty WS
```

### Check the kernel logs for any memory-related errors
```shell
Get-EventLog System -Source Microsoft-Windows-Kernel-Power | Where-Object {$_.EventID -eq 41}
```

## Repair

### Reduce the number of applications or processes running on the host by shutting down unneeded services.
```shell


#!/bin/bash



# Stop the service

Get-Service -Name ${SERVICE_NAME} | Stop-Service 



# Disable the service from starting automatically on boot

Set-Service -Name ${SERVICE_NAME} -StartupType Disabled 


```

# Note
---

Before you proceed with changing the instance type, please be aware that the current instance will restart during the process. Changing the instance type involves stopping the current instance, resizing its resources, and then starting it again with the new configuration.

### Changing the Machine type in GCP
```shell
gcloud compute instances set-machine-type ${INSTANCE_ID} --machine-type=${INSTANCE_TYPE} --zone=${ZONE}
```

### Change the size of an Azure VM using the Azure CLI
```shell
az vm resize --resource-group ${RESOURCE_GROUP_NAME} --name ${INSTANCE_ID} --size ${INSTANCE_TYPE}
```

### Changing AWS Instance type Using AWS CLI
```shell
aws ec2 modify-instance-attribute --instance-id ${INSTANCE_ID} --instance-type ${INSTANCE_TYPE}
```