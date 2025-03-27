param networks array = [{
    name:'network-3'
    address:'10.0.0.0/16'
    subnets:[
      {
        name: 'private'
        addressPrefix: '10.0.0.0/24'
      }
      {
        name: 'GatewaySubnet'
        addressPrefix: '10.0.1.0/24'
      }]
  }
  ]
param location string = resourceGroup().location

module vm_template '../atoms/vnet.bicep' = [for network in networks: {
  name: network.name
  params: {
    network_name:network.name
    address_prefix:network.address
    subnets: network.subnets
    location: location
  }
}]

module vmback '../atoms/vm-with-nsg.bicep' = {
  name: 'vm-back'
  params: {
    network_name: networks[0].name
    location:location
    vm_name:'vm-back'
    subnet_name:networks[0].subnets[0].name
    with_public_ip:false
  }
  dependsOn:[vm_template]
}

