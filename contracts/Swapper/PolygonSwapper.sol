//SPDX-License-Identifier: LICENSED
pragma solidity ^0.7.0;
pragma abicoder v2;
import "../interfaces/ERC20Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../libraries/TransferHelper.sol";
import "./quickswap/interfaces/IUniswapV2Pair.sol";
import "./quickswap/libraries/UniswapV2Library.sol";
import "./satin/interfaces/IBasePair.sol";
import "./satin/interfaces/IBaseV1Router01.sol";
import "../interfaces/PriceOracle.sol";
import "../interfaces/IVault.sol";

contract PolygonSwapper is Ownable {
    using SafeMath for uint256;
    address public vault = 0xd1bb7d35db39954d43e16f65F09DD0766A772cFF; // CASH vault
    address public factory = 0x5757371414417b8C6CAad45bAeF941aBc7d3Ab32; // quickswap factory

    address public CASH = 0x80487b4f8f70e793A81a42367c225ee0B94315DF; // CASH
    address public WMATIC = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
    address public USDT = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;
    address public OKSE = 0xFf1674D39dEf5d3840f4021FAD2c5D4F20520557;
    address public USDC = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
    address public DAI = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063;

    address public router = 0x1Bc01517Bda7135B00d629B61DCe41F7AF070C53; // Satin router

    uint256 slippage = 3000;
    uint256 public constant SLIPPAGE_MAX = 1000000;
    address public priceOracle = 0xcbeDEe9C29E92d61adD691dE46bc6d4F4Bb070A7;
    mapping(address => address) public middleTokenList;

    event PriceOracleUpdated(address priceOracle);
    event SlippageUpdated(uint256 slippage);
    event MiddleTokenUpdated(address tokenAddr, address middleToken);

    constructor() {}

    function _swap(
        uint256[] memory amounts,
        address[] memory path,
        address _to
    ) external {
        if (path[0] == CASH) {
            swapCash(_to);
        } else if (path[0] == OKSE) {
            swapOkse(_to);
        } else {
            swapInQuickSwap(amounts, path, _to);
        }
    }

    function swapCash(address _to) public {
        // redeem
        uint256 _amount = ERC20Interface(CASH).balanceOf(address(this));
        uint256 _minimumUnitAmount = 0;
        IVault(vault).redeem(_amount, _minimumUnitAmount);
        // convert USDC to USDT
        convertToUsdt(DAI, address(this));
        // convert DAI to USDT
        convertToUsdt(USDC, address(this));
        uint256 usdtBalance = ERC20Interface(USDT).balanceOf(address(this));
        TransferHelper.safeTransfer(USDT, _to, usdtBalance);
    }

    function swapOkse(address _to) public {
        uint256 amountIn = ERC20Interface(OKSE).balanceOf(address(this));
        TransferHelper.safeApprove(OKSE, address(router), amountIn);
        IBaseV1Router01(router).swapExactTokensForTokensSimple(
            amountIn,
            0,
            OKSE,
            CASH,
            false,
            address(this),
            block.timestamp
        );
        swapCash(_to);
    }

    function swapInQuickSwap(
        uint256[] memory amounts,
        address[] memory path,
        address _to
    ) public {
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

    function convertToUsdt(address token, address _to) public {
        uint256 amountIn = ERC20Interface(token).balanceOf(address(this));
        if (amountIn == 0) return;
        address[] memory path = new address[](2);
        path[0] = token;
        path[1] = USDT;
        uint256[] memory amounts = UniswapV2Library.getAmountsOut(
            factory,
            amountIn,
            path
        );
        swapInQuickSwap(amounts, path, _to);
    }

    function getAmountsInForCash(
        uint256 amountOut,
        address[] memory path
    ) public view returns (uint256[] memory amounts) {
        amounts = new uint256[](2);
        uint256 cashPrice = IVault(vault).price();
        require(cashPrice > 0, "cash price error");
        uint256 amountIn = amountOut.mul(10 ** 30).div(cashPrice);
        amounts[0] = amountIn;
        amounts[1] = amountOut;
    }

    function getAmountsIn(
        uint256 amountOut,
        address[] memory path
    ) external view returns (uint256[] memory amounts) {
        if (path[0] == CASH) {
            amounts = getAmountsInForCash(amountOut, path);
        } else if (path[0] == OKSE) {
            amounts = getAmountsInForCash(amountOut, path);
            address[] memory newPath = new address[](2);
            newPath[0] = OKSE;
            newPath[1] = CASH;
            amounts = getAmountsInFromSatin(amounts[0], newPath);
            amounts[1] = amountOut;
        } else {
            return UniswapV2Library.getAmountsIn(factory, amountOut, path);
        }
    }

    function getAmountsInFromSatin(
        uint256 amountOut,
        address[] memory path
    ) public view returns (uint256[] memory amounts) {
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
        for (uint256 i = 0; i < path.length - 2; i++) {
            routes[i].from = path[i];
            routes[i].to = path[i + 1];
            routes[i].stable = false;
        }
        amounts = IBaseV1Router01(router).getAmountsOut(amounts[0], routes);
        amounts[0] = amountIn.mul(amountOut).div(amounts[path.length - 1]);
        amounts[path.length - 1] = amountOut;
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

    function getAmountOutForCash(
        uint256 amountIn
    ) public view returns (uint256[] memory amounts) {
        amounts = new uint256[](2);
        uint256 cashPrice = IVault(vault).price();
        uint256 amountOut = amountIn.mul(cashPrice).div(10 ** 30);
        amounts[0] = amountIn;
        amounts[1] = amountOut;
    }

    function getAmountsOut(
        uint256 amountIn,
        address[] memory path
    ) external view returns (uint256[] memory amounts) {
        if (path[0] == CASH) {
            return getAmountOutForCash(amountIn);
        } else if (path[0] == OKSE && path[1] == USDT) {
            address[] memory newPath = new address[](2);
            newPath[0] = OKSE;
            newPath[1] = CASH;
            amounts = getAmountsOutFromSatin(amountIn, newPath);
            return getAmountOutForCash(amountIn);
        } else {
            return UniswapV2Library.getAmountsOut(factory, amountIn, path);
        }
    }

    function getAmountsOutFromSatin(
        uint256 amountIn,
        address[] memory path
    ) public view returns (uint256[] memory amounts) {
        IBaseV1Router01.route[] memory routes = new IBaseV1Router01.route[](
            path.length - 1
        );
        for (uint256 i = 0; i < path.length - 2; i++) {
            routes[i].from = path[i];
            routes[i].to = path[i + 1];
            routes[i].stable = false;
        }
        return IBaseV1Router01(router).getAmountsOut(amountIn, routes);
    }

    function GetReceiverAddress(
        address[] memory path
    ) external view returns (address) {
        if (path[0] == CASH || path[0] == OKSE) {
            return address(this);
        }
        return UniswapV2Library.pairFor(factory, path[0], path[1]);
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

    function setPriceOracle(address _priceoracle) external onlyOwner {
        priceOracle = _priceoracle;
        emit PriceOracleUpdated(priceOracle);
    }

    function setSlippage(uint256 _slippage) external onlyOwner {
        require(_slippage <= SLIPPAGE_MAX, "overflow slippage");
        slippage = _slippage;
        emit SlippageUpdated(slippage);
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
}
