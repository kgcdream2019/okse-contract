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
    address public constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    mapping(address => address) public tokenList;
    // BNB pair
    address public constant OKSE = 0x606FB7969fC1b5CAd58e64b12Cf827FB65eE4875;
    address public constant SHIB = 0x2859e4544C4bB03966803b044A93563Bd2D0DD4D;
    address public constant DOGE = 0xbA2aE424d960c26247Dd6c32edC70B295c744C43;
    address public constant MCRT = 0x4b8285aB433D8f69CB48d5Ad62b415ed1a221e4f;
    address public constant TWT = 0x4B0F1812e5Df2A09796481Ff14017e6005508003;
    address public constant FLOKI = 0xfb5B838b6cfEEdC2873aB27866079AC55363D37E;
    address public constant BRISE = 0x8FFf93E810a2eDaaFc326eDEE51071DA9d398E83;
    address public constant VOLT = 0x7db5af2B9624e1b3B4Bb69D6DeBd9aD1016A58Ac;
    address public constant ARV = 0x6679eB24F59dFe111864AEc72B443d1Da666B360;
    // BUSD pair
    address public constant TOR = 0x1d6Cbdc6b29C6afBae65444a1f65bA9252b8CA83;
    address public constant HAY = 0x0782b6d8c4551B9760e74c0545a9bCD90bdc41E5;
    address public constant WOM = 0xAD6742A35fB341A9Cc6ad674738Dd8da98b94Fb1;
    address public constant USTC = 0x23396cF899Ca06c4472205fC903bDB4de249D6fC;
    address public constant BTT = 0x352Cb5E19b12FC216548a2677bD0fce83BaE434B;
    address public constant TRX = 0x85EAC5Ac2F758618dFa09bDbe0cf174e7d574D5B;
    event TokenSwapPathUpdated(address tokenAddr, address middleToken);

    constructor(address _factory) {
        factory = _factory;
        _setMiddleToken(OKSE, WBNB);
        _setMiddleToken(SHIB, WBNB);
        _setMiddleToken(DOGE, WBNB);
        _setMiddleToken(MCRT, WBNB);
        _setMiddleToken(TWT, WBNB);
        _setMiddleToken(FLOKI, WBNB);
        _setMiddleToken(BRISE, WBNB);
        _setMiddleToken(VOLT, WBNB);
        _setMiddleToken(ARV, WBNB);
        // ---------------------
        _setMiddleToken(TOR, BUSD);
        _setMiddleToken(HAY, BUSD);
        _setMiddleToken(WOM, BUSD);
        _setMiddleToken(USTC, BUSD);
        _setMiddleToken(BTT, BUSD);
        _setMiddleToken(TRX, BUSD);
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

    function getAmountsIn(
        uint256 amountOut,
        address[] memory path
    ) external view returns (uint256[] memory amounts) {
        return UniswapV2Library.getAmountsIn(factory, amountOut, path);
    }

    function getAmountsOut(
        uint256 amountIn,
        address[] memory path
    ) external view returns (uint256[] memory amounts) {
        return UniswapV2Library.getAmountsOut(factory, amountIn, path);
    }

    function GetReceiverAddress(
        address[] memory path
    ) external view returns (address) {
        return UniswapV2Library.pairFor(factory, path[0], path[1]);
    }

    function getOptimumPath(
        address token0,
        address token1
    ) external view returns (address[] memory path) {
        if (tokenList[token0] != address(0) && token1 == USDT) {
            path = new address[](3);
            path[0] = token0;
            path[1] = tokenList[token0];
            path[2] = USDT;
        } else {
            path = new address[](2);
            path[0] = token0;
            path[1] = token1;
        }
    }

    function _setMiddleToken(address tokenAddr, address middleToken) internal {
        tokenList[tokenAddr] = middleToken;
        emit TokenSwapPathUpdated(tokenAddr, middleToken);
    }

    function setMiddleToken(
        address tokenAddr,
        address middleToken
    ) external onlyOwner {
        _setMiddleToken(tokenAddr, middleToken);
    }
}
