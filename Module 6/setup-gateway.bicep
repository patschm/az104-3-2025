param location string = resourceGroup().location
param network_name string = 'network-1'
param address_prefix string = '192.168.0.0/16'
param subnets array = [
  {
    name: 'video'
    addressPrefix: '192.168.10.0/25'
  }
  {
    name: 'images'
    addressPrefix: '192.168.50.0/25'
  }
  {
    name: 'gateway'
    addressPrefix: '192.168.100.0/25'
  }
]

// Don't forget the following commands (shown in output)
// az vm run-command invoke -g <resource-group> --name <vm-name> --command-id RunShellScript --scripts "sudo apt-get update && sudo apt-get install -y nginx"
// az vm run-command invoke -g <resource-group> --name <vm-name> --command-id RunShellScript --scripts "sudo apt update; sudo apt install -y apache2"

module vnet '../atoms/vnet.bicep' = {
  name: network_name
  params: {
    network_name:network_name
    address_prefix:address_prefix
    subnets: subnets
    location: location
  }
}

module vmimg '../atoms/vm-ubuntu-web.bicep' = {
  name:'vm-images-apache'
  params: {
    location:location
    vm_name: 'vm-images-apache'
    network_name:network_name
    subnet_name:subnets[0].name
    with_public_ip:false
    webServerVersion:'apache'
  }
  dependsOn:[vnet]
}
module vmvid '../atoms/vm-ubuntu-web.bicep' = {
  name:'vm-video-nginx'
  params: {
    location:location
    vm_name: 'vm-video-nginx'
    network_name:network_name
    subnet_name:subnets[1].name
    with_public_ip:false
    webServerVersion:'nginx'
  }
  dependsOn:[vnet]
}

output websvr array = [vmimg.outputs.clicmd, vmvid.outputs.clicmd]

