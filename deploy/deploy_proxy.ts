import { HardhatRuntimeEnvironment } from 'hardhat/types'
import { DeployFunction } from 'hardhat-deploy/types'
const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    const { deployments, getNamedAccounts } = hre
    const { deploy } = deployments
  
    const { deployer } = await getNamedAccounts()
    
    const OkseCard_Implementation = "0x43DC5Bbaa0d10d3B3dA74d7aCBb6ec777EF2Bc73"

    const DefaultProxyAdmin = await deploy('ProxyAdmin', {
      from: deployer,
      args: [],
      log: true,
    })

    
    const OkseCard_Proxy = await deploy('TransparentUpgradeableProxy',{
      from: deployer,
      args: [OkseCard_Implementation, DefaultProxyAdmin.address,'0x'],
      log: true,
    })
    console.log("OkseCard_Proxy = ", OkseCard_Proxy.address);
}
export default func
func.tags = ['Proxy']