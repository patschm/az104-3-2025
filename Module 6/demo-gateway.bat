set resourcegroup="gatewaydemo"
set location="westeurope"
set file="%~dp0setup-gateway.bicep"
call az group create --name %resourcegroup% --location %location%
call az deployment group create --resource-group %resourcegroup% --template-file %file%
timeout /t 10
call az vm run-command invoke -g %resourcegroup% --name "vm-video-nginx" --command-id RunShellScript --scripts "sudo apt-get update && sudo apt-get install -y nginx"
call az vm run-command invoke -g %resourcegroup% --name "vm-images-apache" --command-id RunShellScript --scripts "sudo apt update; sudo apt install -y apache2"

