//SPDX-License-Identifier: LICENSED

pragma solidity ^0.7.0;
import "../interfaces/AggregatorV3Interface.sol";
import "../interfaces/ERC20Interface.sol";
import "../libraries/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-core/contracts/libraries/TickMath.sol";
import "@uniswap/v3-core/contracts/libraries/FixedPoint96.sol";
import "@uniswap/v3-core/contracts/libraries/FullMath.sol";
import "@uniswap/v3-periphery/contracts/libraries/PoolAddress.sol";

contract UniswapV3TwapPriceFeed2 is AggregatorV3Interface, Ownable {
    using SafeMath for uint256;
    address public immutable factory;
    address public immutable USDC;
    address public immutable WETH;
    address public immutable TOKEN;
    uint24 public fee0;
    uint24 public fee1;
    uint256 public testAmountsIn;
    uint32 public twapInterval; // 0 => current price, > 0 => twap price
    uint8 _decimals;
    string _description;
    uint256 _version;

    // events

    constructor(
        address _token,
        address _usdt,
        address _weth,
        address _factory
    ) {
        TOKEN = _token;
        USDC = _usdt;
        WETH = _weth;
        fee0 = 3000;
        fee1 = 500;
        factory = _factory;
        testAmountsIn = 1 ether;
        _decimals = 8;
        _description = "twap price feed 2 for uniswap v3";
        _version = 1;
    }

    function setDecimals(uint8 _value) public onlyOwner {
        _decimals = _value;
    }

    function setDescription(string memory _value) public onlyOwner {
        _description = _value;
    }

    function setVersion(uint256 _value) public onlyOwner {
        _version = _value;
    }

    function setTestAmount(uint256 _value) public onlyOwner {
        testAmountsIn = _value;
    }

    function setPoolFee(uint24 _fee0, uint24 _fee1) public onlyOwner {
        fee0 = _fee0;
        fee1 = _fee1;
    }

    function setTwapInterval(uint32 _value) public onlyOwner {
        twapInterval = _value;
    }

    // function setPeriod(uint256 _period) public onlyOwner {
    //     PERIOD = _period;
    // }

    function decimals() external view override returns (uint8) {
        return _decimals;
    }

    function description() external view override returns (string memory) {
        return _description;
    }

    function version() external view override returns (uint256) {
        return _version;
    }

    // getRoundData and latestRoundData should both raise "No data present"
    // if they do not have data to report, instead of returning unset values
    // which could be misinterpreted as actual reported values.
    function getRoundData(uint80 _roundId)
        external
        view
        override
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        roundId = _roundId;
        answer = getPrice();
        startedAt = block.timestamp;
        updatedAt = block.timestamp;
        answeredInRound = uint80(block.number);
    }

    function latestRoundData()
        external
        view
        override
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        roundId = uint80(block.number);
        answer = getPrice();
        startedAt = block.timestamp;
        updatedAt = block.timestamp;
        answeredInRound = uint80(block.number);
    }

    function getQuoteAmount(
        uint256 baseAmount,
        address baseToken,
        address quoteToken,
        uint24 fee
    ) public view returns (uint256 quoteAmount) {
        address poolAddress = PoolAddress.computeAddress(
            factory,
            PoolAddress.getPoolKey(baseToken, quoteToken, fee)
        );
        uint160 sqrtPriceX96;
        if (twapInterval == 0) {
            (sqrtPriceX96, , , , , , ) = IUniswapV3Pool(poolAddress).slot0();
        } else {
            uint32[] memory secondsAgos = new uint32[](2);
            secondsAgos[0] = twapInterval;
            secondsAgos[1] = 0;
            (int56[] memory tickCumulatives, ) = IUniswapV3Pool(poolAddress)
                .observe(secondsAgos);
            sqrtPriceX96 = TickMath.getSqrtRatioAtTick(
                int24((tickCumulatives[1] - tickCumulatives[0]) / twapInterval)
            );
        }
        uint160 sqrtRatioX96 = sqrtPriceX96;
        if (sqrtRatioX96 <= type(uint128).max) {
            uint256 ratioX192 = uint256(sqrtRatioX96) * sqrtRatioX96;
            quoteAmount = baseToken < quoteToken
                ? FullMath.mulDiv(ratioX192, baseAmount, 1 << 192)
                : FullMath.mulDiv(1 << 192, baseAmount, ratioX192);
        } else {
            uint256 ratioX128 = FullMath.mulDiv(
                sqrtRatioX96,
                sqrtRatioX96,
                1 << 64
            );
            quoteAmount = baseToken < quoteToken
                ? FullMath.mulDiv(ratioX128, baseAmount, 1 << 128)
                : FullMath.mulDiv(1 << 128, baseAmount, ratioX128);
        }
    }

    function getPrice() public view returns (int256) {
        uint256 amount1 = getQuoteAmount(testAmountsIn, TOKEN, WETH, fee0);
        uint256 quoteAmount = getQuoteAmount(amount1, WETH, USDC, fee1);
        uint256 _dec = _decimals + ERC20Interface(TOKEN).decimals();
        uint256 usdcDecimal = ERC20Interface(USDC).decimals();
        int256 price;
        if (_dec >= usdcDecimal) {
            price = int256(
                (quoteAmount.mul(uint256(10**uint256(_dec - usdcDecimal)))).div(
                    testAmountsIn
                )
            );
        } else {
            price = int256(
                quoteAmount.div(uint256(10**uint256(usdcDecimal - _dec))).div(
                    testAmountsIn
                )
            );
        }
        return price;
    }
}
