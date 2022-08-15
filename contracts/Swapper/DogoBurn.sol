//SPDX-License-Identifier: LICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.7.0;
import "./uniswapv2/interfaces/IUniswapV2Router.sol";
import "./uniswapv2/interfaces/IERC20.sol";
import "../interfaces/IWETH9.sol";
import "../libraries/TransferHelper.sol";
import "../openzepplin/access/Ownable.sol";

contract DogoBurn is Ownable {
    address public DOGE = 0xbA2aE424d960c26247Dd6c32edC70B295c744C43;
    address public DOGO = 0x9E6B3E35c8f563B45d864f9Ff697A144ad28A371;
    address public WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address public DEAD_ADDR = 0x000000000000000000000000000000000000dEaD;
    IUniswapV2Router02 public swapV2Router =
        IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);

    function swapTokensForToken(uint256 tokenAmount, address[] memory path)
        private
    {
        IERC20Uniswap(path[0]).approve(address(swapV2Router), tokenAmount);

        // make the swap
        swapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ERC20Token
            path,
            address(this),
            block.timestamp + 5
        );
    }

    function swapAndBurn()  public onlyOwner {
        uint256 balance = IERC20Uniswap(DOGE).balanceOf(address(this));
        address[] memory path = new address[](2);
        path[0] = DOGE;
        path[1] = WBNB;
        swapTokensForToken(balance, path);
        uint256 wbnbAmount = IERC20Uniswap(WBNB).balanceOf(address(this));
        require(wbnbAmount > 0.01 ether, "not enough");
        IWETH9(WBNB).withdraw(0.01 ether);
        TransferHelper.safeTransferETH(msg.sender, 0.01 ether);
        wbnbAmount = wbnbAmount - 0.01 ether;
        path[0] = WBNB;
        path[1] = DOGO;
        swapTokensForToken(wbnbAmount, path);

        TransferHelper.safeTransfer(
            DOGO,
            DEAD_ADDR,
            IERC20Uniswap(DOGO).balanceOf(address(this))
        );
    }

    // verified
    receive() external payable {
        // require(msg.sender == WETH, 'Not WETH9');
    }
}
