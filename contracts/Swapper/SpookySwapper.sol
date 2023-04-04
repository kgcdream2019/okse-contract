//SPDX-License-Identifier: LICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.7.0;
import "./spookyswap/interfaces/IUniswapV2Pair.sol";
import "./spookyswap/libraries/UniswapV2Library.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SpookySwapper is Ownable {
    // factory address for AMM dex, normally we use spookyswap on fantom chain.
    address public factory;
    address public constant TOMB = 0x6c021Ae822BEa943b2E66552bDe1D2696a53fbB7;
    address public constant WFTM = 0x21be370D5312f44cB42ce377BC9b8a0cEF1A4C83;
    address public constant USDT = 0x049d68029688eAbF473097a2fC38ef61633A3C7A;
    address public constant USDC = 0x04068DA6C83AFCFA0e13ba15A6696662335D5B75;
    address public constant OKSE = 0x3b53D2C7B44d40BE05Fa5E2309FFeB6eB2492d88;
    address public constant BOO = 0x841FAD6EAe12c286d1Fd18d1d525DFfA75C7EFFE;
    address public constant TOR = 0x74E23dF9110Aa9eA0b6ff2fAEE01e740CA1c642e;
    address public constant BTC = 0x321162Cd933E2Be498Cd2267a90534A804051b11;
    address public constant ETH = 0x74b23882a30290451A17c44f4F05243b6b58C76d;
    address public constant miMatic = 0xfB98B335551a418cD0737375a2ea0ded62Ea213b;
    
    mapping(address => address) public tokenList;
    event TokenSwapPathUpdated(address tokenAddr, address middleToken);

    constructor(address _factory) {
        factory = _factory;
        _setMiddleToken(BOO, WFTM);
        _setMiddleToken(BTC, WFTM);
        _setMiddleToken(ETH, WFTM);
        _setMiddleToken(TOMB, WFTM);
        _setMiddleToken(TOR, WFTM);
        _setMiddleToken(miMatic, USDC);
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
