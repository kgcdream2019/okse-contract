//SPDX-License-Identifier: LICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.7.0;
import "./pancakeswap/interfaces/IUniswapV2Pair.sol";
import "./pancakeswap/libraries/UniswapV2Library.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PancakeSwapper is Ownable {
    // factory address for AMM dex, normally we use spookyswap on fantom chain.
    address public factory;
    address public constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address public constant BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    mapping(address => bool) public tokenList;
    address public constant OKSE = 0x606FB7969fC1b5CAd58e64b12Cf827FB65eE4875;
    address public constant SHIB = 0x2859e4544C4bB03966803b044A93563Bd2D0DD4D;
    address public constant VOLT = 0x7db5af2B9624e1b3B4Bb69D6DeBd9aD1016A58Ac;
    address public constant ARV = 0x6679eB24F59dFe111864AEc72B443d1Da666B360;
    event TokenEnableUpdaated(address tokenAddr, bool bEnable);

    constructor(address _factory) {
        factory = _factory;
        _setTokenEnable(OKSE, true);
        _setTokenEnable(SHIB, true);
        _setTokenEnable(VOLT, true);
        _setTokenEnable(ARV, true);
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
            (address token0, ) = UniswapV2Library.sortTokens(input, output);
            uint256 amountOut = amounts[i + 1];
            (uint256 amount0Out, uint256 amount1Out) = input == token0
                ? (uint256(0), amountOut)
                : (amountOut, uint256(0));
            address to = i < path.length - 2
                ? UniswapV2Library.pairFor(factory, output, path[i + 2])
                : _to;
            IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output))
                .swap(amount0Out, amount1Out, to, new bytes(0));
        }
    }

    function getAmountsIn(uint256 amountOut, address[] memory path)
        external
        view
        returns (uint256[] memory amounts)
    {
        return UniswapV2Library.getAmountsIn(factory, amountOut, path);
    }

    function GetReceiverAddress(address[] memory path)
        external
        view
        returns (address)
    {
        return UniswapV2Library.pairFor(factory, path[0], path[1]);
    }

    function getOptimumPath(address token0, address token1)
        external
        view
        returns (address[] memory path)
    {
        if (tokenList[token0] && token1 == BUSD) {
            path = new address[](3);
            path[0] = token0;
            path[1] = WBNB;
            path[2] = BUSD;
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
