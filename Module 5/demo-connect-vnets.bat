set filewest="%~dp0multi-vnets.bicep"
set filenorth="%~dp0other-region-vnet.bicep"
call az group create --name "network1-grp" --location "westeurope"
call az group create --name "network2-grp" --location "northeurope"
call az deployment group create -g "network1-grp" --template-file %filewest%
call az deployment group create -g "network2-grp" --template-file %filenorth%

