param network_name string = 'network-1'
param subnet_name string = 'subnet-1'
param location string = resourceGroup().location

module vm_template '../atoms/vm.bicep' = {
  name: 'vm1'
  params: {
    network_name:network_name
    subnet_name:subnet_name
    location: location
    with_public_ip:false
  }
}

module vnet_template '../atoms/webapp.bicep' = {
  name: network_name
  params: {
    location:location
  }
}
