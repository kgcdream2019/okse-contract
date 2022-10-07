//SPDX-License-Identifier: LICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.7.0;
import "./cherryswap/interfaces/ICherryPair.sol";
import "./cherryswap/libraries/CherryLibrary.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CherrySwapper is Ownable {
    // factory address for AMM dex, normally we use spookyswap on fantom chain.
    address public factory;
    address public constant WOKT = 0x8F8526dbfd6E38E3D8307702cA8469Bae6C56C15;
    address public constant USDT = 0x382bB369d343125BfB2117af9c149795C6C65C50;
    mapping(address => bool) public tokenList;
    address public constant OKSE = 0xA844C05ae51DdafA6c4d5c801DE1Ef5E6F626bEC;
    event TokenEnableUpdaated(address tokenAddr, bool bEnable);

    constructor(address _factory) {
        factory = _factory;
        _setTokenEnable(OKSE, true);
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
            (address token0, ) = CherryLibrary.sortTokens(input, output);
            uint256 amountOut = amounts[i + 1];
            (uint256 amount0Out, uint256 amount1Out) = input == token0
                ? (uint256(0), amountOut)
                : (amountOut, uint256(0));
            address to = i < path.length - 2
                ? CherryLibrary.pairFor(factory, output, path[i + 2])
                : _to;
            ICherryPair(CherryLibrary.pairFor(factory, input, output)).swap(
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
        return CherryLibrary.getAmountsIn(factory, amountOut, path);
    }

    function getAmountsOut(uint256 amountIn, address[] memory path)
        external
        view
        returns (uint256[] memory amounts)
    {
        return CherryLibrary.getAmountsOut(factory, amountIn, path);
    }

    function GetReceiverAddress(address[] memory path)
        external
        view
        returns (address)
    {
        return CherryLibrary.pairFor(factory, path[0], path[1]);
    }

    function getOptimumPath(address token0, address token1)
        external
        view
        returns (address[] memory path)
    {
        if (tokenList[token0] && token1 == USDT) {
            path = new address[](3);
            path[0] = token0;
            path[1] = WOKT;
            path[2] = USDT;
        } else {
            path = new address[](2);
            path[0] = token0;
            path[1] = token1;
        }
    }

    function _setTokenEnable(address tokenAddr, bool bEnable) internal {
        tokenList[tokenAddr] = bEnable;
        emit TokenEnableUpdaated(tokenAddr, bEnable);
    }

    function setTokenEnable(address tokenAddr, bool bEnable)
        external
        onlyOwner
    {
        _setTokenEnable(tokenAddr, bEnable);
    }
}
