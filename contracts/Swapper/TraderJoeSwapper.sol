//SPDX-License-Identifier: LICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.7.0;
import "./traderjoe/interfaces/IJoePair.sol";
import "./traderjoe/libraries/JoeLibrary.sol";

contract TraderJoeSwapper {
    // factory address for AMM dex, normally we use spookyswap on fantom chain.
    address public factory;
    address public constant WAVAX = 0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7;
    // address public constant USDC = 0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E;
    address public constant USDC = 0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664;
    address public constant OKSE = 0xbc7B0223Dd16cbc679c0D04bA3F4530D76DFbA87;

    constructor(address _factory) {
        factory = _factory;
    }

    // **** SWAP ****
    // verified
    // requires the initial amount to have already been sent to the first pair
    function _swap(
        uint256[] memory amounts,
        address[] memory path,
        address _to
    ) external {
        for (uint256 i; i < path.length - 1; i++) {
            (address input, address output) = (path[i], path[i + 1]);
            (address token0, ) = JoeLibrary.sortTokens(input, output);
            uint256 amountOut = amounts[i + 1];
            (uint256 amount0Out, uint256 amount1Out) = input == token0
                ? (uint256(0), amountOut)
                : (amountOut, uint256(0));
            address to = i < path.length - 2
                ? JoeLibrary.pairFor(factory, output, path[i + 2])
                : _to;
            IJoePair(JoeLibrary.pairFor(factory, input, output)).swap(
                amount0Out,
                amount1Out,
                to,
                new bytes(0)
            );
        }
    }

    function getAmountsIn(uint256 amountOut, address[] memory path)
        external
        view
        returns (uint256[] memory amounts)
    {
        return JoeLibrary.getAmountsIn(factory, amountOut, path);
    }

    function getAmountsOut(uint256 amountIn, address[] memory path)
        external
        view
        returns (uint256[] memory amounts)
    {
        return JoeLibrary.getAmountsOut(factory, amountIn, path);
    }

    function GetReceiverAddress(address[] memory path)
        external
        view
        returns (address)
    {
        return JoeLibrary.pairFor(factory, path[0], path[1]);
    }

    function getOptimumPath(address token0, address token1)
        external
        view
        returns (address[] memory path)
    {
        if (token0 == OKSE && token1 == USDC) {
            //OKSE-USDC pair
            path = new address[](3);
            path[0] = OKSE;
            path[1] = WAVAX;
            path[2] = USDC;
        } else {
            path = new address[](2);
            path[0] = token0;
            path[1] = token1;
        }
    }
}
