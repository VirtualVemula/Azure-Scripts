# Creation of Azure Virtual Network
$rule1 = New-AzNetworkSecurityRuleConfig -Name rule1 -SourceAddressPrefix Internet -DestinationPortRange 22,3389 `
        -SourcePortRange * -DestinationAddressPrefix 10.0.0.0/16 -Protocol Tcp -Access Allow -Priority 3000 -Direction Inbound
$nsg1 = New-AzNetworkSecurityGroup -Name nsg1 -Location 'Central US' -ResourceGroupName ProjABC -SecurityRules $rule1
$route1 = New-AzRouteConfig -Name route1 -AddressPrefix 10.0.1.0/24 -NextHopType VirtualAppliance -NextHopIpAddress 10.0.0.4
$route2 = New-AzRouteConfig -Name route2 -AddressPrefix 10.0.2.0/24 -NextHopType VirtualAppliance -NextHopIpAddress 10.0.0.4
$myrt = New-AzRouteTable -Name myrt -ResourceGroupName ProjABC -Location 'Central US' -Route $route1,$route2 
$subnet1 = New-AzVirtualNetworkSubnetConfig -Name subnet1 -AddressPrefix 10.0.0.0/24 -RouteTable $myrt -NetworkSecurityGroup $nsg1
$subnet2 = New-AzVirtualNetworkSubnetConfig -Name subnet2 -AddressPrefix 10.0.1.0/24 -RouteTable $myrt -NetworkSecurityGroup $nsg1
$subnet3 = New-AzVirtualNetworkSubnetConfig -Name subnet3 -AddressPrefix 10.0.2.0/24 -RouteTable $myrt -NetworkSecurityGroup $nsg1
New-AzVirtualNetwork -Name vnet1 -Location 'Central US' -AddressPrefix 10.0.0.0/16 -Subnet $subnet1, $subnet2, $subnet3 -ResourceGroupName ProjABC