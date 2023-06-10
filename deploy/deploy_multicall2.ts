import { HardhatRuntimeEnvironment } from 'hardhat/types'
import { DeployFunction } from 'hardhat-deploy/types'
const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    const { deployments, getNamedAccounts } = hre
    const { deploy } = deployments
  
    const { deployer } = await getNamedAccounts()
    const multicall2 = await deploy('Multicall2', {
      from: deployer,
      args: [],
      log: true,
    })
}
export default func
func.tags = ['multicall2']