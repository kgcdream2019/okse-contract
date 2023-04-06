//SPDX-License-Identifier: LICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.7.0;
pragma abicoder v2;
import "./satin/interfaces/IBasePair.sol";
import "./satin/interfaces/IBaseV1Router01.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/ERC20Interface.sol";
import "../libraries/TransferHelper.sol";
import "../libraries/SafeMath.sol";
import "../interfaces/PriceOracle.sol";

// proxyFactory  address 0xFB01070868645fcd0a75e567074CAc19b11B3801
// BaseV1Factory 0x30030Aa4bc9bF07005cf61803ac8D0EB53e576eC
// BaseV1Router01 0x1Bc01517Bda7135B00d629B61DCe41F7AF070C53
// SatinLibrary 0x26DdAFAF2ec090205ED1bCF60F841Ab3F4A609F5

contract SatinSwapper is Ownable {
    using SafeMath for uint256;
    // factory address for AMM dex, normally we use spookyswap on fantom chain.
    address public router;
    address public constant WMATIC = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
    address public constant USDT = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;
    mapping(address => address) public middleTokenList;
    mapping(address => mapping(address => bool)) public pairStableList;
    uint256 slippage;
    uint256 public constant SLIPPAGE_MAX = 1000000;
    address public priceOracle;

    event MiddleTokenUpdated(address tokenAddr, address middleToken);
    event PairStableUpdated(address tokenA, address tokenB, bool bStable);
    event PriceOracleUpdated(address priceOracle);
    event SlippageUpdated(uint256 slippage);

    constructor(address _router, address _priceOracle) {
        router = _router;
        priceOracle = _priceOracle;
        slippage = 30000; // 3%
    }

    // **** SWAP ****
    // verified
    // requires the initial amount to have already been sent to the first pair
    function _swap(
        uint256[] memory amounts,
        address[] memory path,
        address _to
    ) external returns (uint256 amountOut) {
        require(path.length >= 2, "invalid path");
        uint256 amountInMaximum = ERC20Interface(path[0]).balanceOf(
            address(this)
        );
        TransferHelper.safeApprove(path[0], address(router), amountInMaximum);
        uint amountOutMin = amounts[amounts.length - 1].sub(
            amounts[amounts.length - 1].mul(slippage).div(SLIPPAGE_MAX)
        );
        IBaseV1Router01.route[] memory routes = new IBaseV1Router01.route[](
            path.length - 1
        );
        for (uint256 i = 0; i < path.length - 1; i++) {
            routes[i].from = path[i];
            routes[i].to = path[i + 1];
            routes[i].stable = pairStableList[path[i]][path[i + 1]];
        }
        IBaseV1Router01(router).swapExactTokensForTokens(
            amountInMaximum,
            amountOutMin,
            routes,
            _to,
            block.timestamp
        );
    }

    function getUsdAmount(
        address market,
        uint256 assetAmount,
        address _priceOracle
    ) public view returns (uint256 usdAmount) {
        uint256 usdPrice = PriceOracle(_priceOracle).getUnderlyingPrice(market);
        require(usdPrice > 0, "upe");
        usdAmount = (assetAmount.mul(usdPrice)).div(10 ** 8);
    }

    // verified not
    function getAssetAmount(
        address market,
        uint256 usdAmount,
        address _priceOracle
    ) public view returns (uint256 assetAmount) {
        uint256 usdPrice = PriceOracle(_priceOracle).getUnderlyingPrice(market);
        require(usdPrice > 0, "usd price error");
        assetAmount = (usdAmount.mul(10 ** 8)).div(usdPrice);
    }

    function getAmountsIn(
        uint256 amountOut,
        address[] memory path
    ) external view returns (uint256[] memory amounts) {
        require(path.length == 2 || path.length == 3, "invalid length");
        uint256 usdAmount = getUsdAmount(
            path[path.length - 1],
            amountOut,
            priceOracle
        );
        uint256 amountIn = getAssetAmount(path[0], usdAmount, priceOracle);
        amounts = new uint256[](path.length);
        amountIn = amountIn.add(amountIn.mul(slippage).div(SLIPPAGE_MAX));
        IBaseV1Router01.route[] memory routes = new IBaseV1Router01.route[](
            path.length - 1
        );
        for (uint256 i = 0; i < path.length - 1; i++) {
            routes[i].from = path[i];
            routes[i].to = path[i + 1];
            routes[i].stable = pairStableList[path[i]][path[i + 1]];
        }
        amounts = IBaseV1Router01(router).getAmountsOut(amounts[0], routes);
        amounts[0] = amountIn.mul(amountOut).div(amounts[path.length - 1]);
        amounts[path.length - 1] = amountOut;
    }

    function getAmountsOut(
        uint256 amountIn,
        address[] memory path
    ) external view returns (uint256[] memory amounts) {
        IBaseV1Router01.route[] memory routes = new IBaseV1Router01.route[](
            path.length - 1
        );
        for (uint256 i = 0; i < path.length - 1; i++) {
            routes[i].from = path[i];
            routes[i].to = path[i + 1];
            routes[i].stable = pairStableList[path[i]][path[i + 1]];
        }
        return IBaseV1Router01(router).getAmountsOut(amountIn, routes);
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
        if (middleTokenList[token0] != address(0) && token1 == USDT) {
            path = new address[](3);
            path[0] = token0;
            path[1] = middleTokenList[token0];
            path[2] = USDT;
        } else {
            path = new address[](2);
            path[0] = token0;
            path[1] = token1;
        }
    }

    function _setMiddleToken(address tokenAddr, address middleToken) internal {
        middleTokenList[tokenAddr] = middleToken;
        emit MiddleTokenUpdated(tokenAddr, middleToken);
    }

    function setMiddleToken(
        address tokenAddr,
        address middleToken
    ) external onlyOwner {
        _setMiddleToken(tokenAddr, middleToken);
    }

    function setPairStable(
        address tokenA,
        address tokenB,
        bool bStable
    ) public onlyOwner {
        pairStableList[tokenA][tokenB] = bStable;
        pairStableList[tokenB][tokenA] = bStable;
        emit PairStableUpdated(tokenA, tokenB, bStable);
    }

    function setPriceOracle(address _priceoracle) external onlyOwner {
        priceOracle = _priceoracle;
        emit PriceOracleUpdated(priceOracle);
    }

    function setSlippage(uint256 _slippage) external onlyOwner {
        require(_slippage <= SLIPPAGE_MAX, "overflow slippage");
        slippage = _slippage;
        emit SlippageUpdated(slippage);
    }
}
