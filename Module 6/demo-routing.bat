set resourcegroup="routingdemo"
set location="westeurope"
set file="%~dp0setup-routing.bicep"
call az group create --name %resourcegroup% --location %location%
call az deployment group create --resource-group %resourcegroup% --template-file %file%

