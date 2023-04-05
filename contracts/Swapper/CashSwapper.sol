//SPDX-License-Identifier: LICENSED
pragma solidity ^0.7.0;
import "../interfaces/ERC20Interface.sol";
import "../libraries/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../libraries/TransferHelper.sol";
// 0x2D7a30854DaFA76e151F60d9a60FF53c5F9098D1

interface IVault {
    function calculateRedeemOutput(
        uint256 _amount
    ) external view returns (uint256);

    function primaryStableAddress() external view returns (address);

    function redeem(uint256 _amount, uint256 _minimumUnitAmount) external;
}

contract CashSwapper is Ownable {
    using SafeMath for uint256;
    address public vault;
    address public cash;

    constructor(address _vault, address _cash) {
        vault = _vault;
        cash = _cash;
    }

    function _swap(
        uint256[] memory amounts,
        address[] memory path,
        address _to
    ) external {
        // redeem
        uint256 _amount = ERC20Interface(cash).balanceOf(address(this));
        uint256 _minimumUnitAmount = 0;
        IVault(vault).redeem(_amount, _minimumUnitAmount);
        // convert usdc to usdt
        // convert dai to usdt
    }

    function getAmountsIn(
        uint256 amountOut,
        address[] memory path
    ) external view returns (uint256[] memory amounts) {
        amounts = new uint256[](2);
        uint256 amountIn = IVault(vault).calculateRedeemOutput(1 ether);
        require(amountIn > 0, "very small input or protocol paused");
        amountIn = amountOut.mul(1 ether).div(amountIn);
        amounts[0] = amountIn;
        amounts[1] = amountOut;
    }

    function getAmountsOut(
        uint256 amountIn,
        address[] memory path
    ) external view returns (uint256[] memory amounts) {
        amounts = new uint256[](2);
        uint256 amountOut = IVault(vault).calculateRedeemOutput(amountIn);
        amounts[0] = amountIn;
        amounts[1] = amountOut;
    }

    function GetReceiverAddress(
        address[] memory path
    ) external view returns (address) {
        return address(this);
    }

    function getOptimumPath(
        address token0,
        address token1
    ) external view returns (address[] memory path) {
        path = new address[](2);
        path[0] = token0;
        path[1] = token1;
    }

    function withdrawTokens(address token, address to) public onlyOwner {
        uint256 amount;
        if (token == address(0)) {
            amount = address(this).balance;
            TransferHelper.safeTransferETH(to, amount);
        } else {
            amount = ERC20Interface(token).balanceOf(address(this));
            TransferHelper.safeTransfer(token, to, amount);
        }
    }
}
