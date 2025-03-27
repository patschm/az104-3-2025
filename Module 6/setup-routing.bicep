param network_name string = 'network-1'
param address_prefix string = '192.168.0.0/16'
param location string = resourceGroup().location
param subnets array = [
  {
    name: 'public'
    addressPrefix: '192.168.10.0/25'
  }
  {
    name: 'private'
    addressPrefix: '192.168.50.0/25'
  }
  {
    name: 'DMZ'
    addressPrefix: '192.168.100.0/25'
  }
  {
    name: 'AzureFirewallSubnet'
    addressPrefix: '192.168.200.0/25'
  }
]

var winsvr = {
  publisher: 'microsoftwindowsserver'
  offer:'windowsserver'
  sku:'2019-datacenter-gensecond'
  version:'latest'
  license: 'Windows_Server'
}
var win11 = {
  publisher: 'microsoftwindowsdesktop'
  offer:'windows-11'
  sku:'win11-22h2-pro'
  version:'latest'
  license: 'Windows_Client'
}

module vnet '../atoms/vnet.bicep' = {
  name: network_name
  params: {
    network_name:network_name
    address_prefix:address_prefix
    subnets: subnets
    location: location
  }
}

module vmback '../atoms/vm-with-nsg.bicep' = {
  name: 'vm-back'
  params: {
    network_name: network_name
    location:location
    vm_name:'vm-back'
    subnet_name:subnets[1].name
    image:win11
    with_public_ip:false
  }
  dependsOn:[vnet]
}
module vmfront '../atoms/vm-with-nsg.bicep' = {
  name: 'vm-front'
  params: {
    network_name: network_name
    location:location
    vm_name:'vm-front'
    subnet_name:subnets[0].name
    image: win11
    with_public_ip:true
  }
  dependsOn:[vnet]
}
module vmdmz '../atoms/vm-with-nsg.bicep' = {
  name: 'vm-dmz'
  params: {
    network_name: network_name
    location:location
    vm_name:'vm-dmz'
    subnet_name:subnets[2].name
    image: winsvr
    with_public_ip:false
  }
  dependsOn:[vnet]
}

module storage '../atoms/storage.bicep' = {
  name:'psstooring'
  params: {
    location:location
    storage_name:'psstooring'
  }
}
