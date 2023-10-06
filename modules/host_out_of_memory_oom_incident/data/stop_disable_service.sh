

#!/bin/bash



# Stop the service

Get-Service -Name ${SERVICE_NAME} | Stop-Service 



# Disable the service from starting automatically on boot

Set-Service -Name ${SERVICE_NAME} -StartupType Disabled