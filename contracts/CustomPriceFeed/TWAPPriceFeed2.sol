//SPDX-License-Identifier: LICENSED

pragma solidity ^0.7.0;
import "../interfaces/AggregatorV3Interface.sol";
import "../Swapper/uniswapv2/interfaces/IUniswapV2Router01.sol";
import "../Swapper/uniswapv2/interfaces/IUniswapV2Factory.sol";

import "../Swapper/uniswapv2/libraries/UniswapV2Library.sol";

import "../interfaces/ERC20Interface.sol";
import "../libraries/SafeMath.sol";

import "../libraries/UniswapV2OracleLibrary.sol";
import "../libraries/FixedPoint.sol";

contract TWAPPriceFeed2 is AggregatorV3Interface {
    using SafeMath for uint256;
    using FixedPoint for *;

    uint256 public PERIOD = 1 minutes;
    // price for token-weth pair
    uint256 public price0CumulativeLast;
    uint256 public price1CumulativeLast;
    uint32 public blockTimestampLast;
    FixedPoint.uq112x112 public price0Average;
    FixedPoint.uq112x112 public price1Average;
    // price for weth-usdc pair -------------------
    uint256 public price0CumulativeLast2;
    uint256 public price1CumulativeLast2;
    uint32 public blockTimestampLast2;
    FixedPoint.uq112x112 public price0Average2;
    FixedPoint.uq112x112 public price1Average2;

    function update() public {
        update1();
        update2();
    }

    function update1() public {
        address _factory = IUniswapV2Router01(router).factory();
        address pair = IUniswapV2Factory(_factory).getPair(TOKEN, WETH);

        (
            uint256 price0Cumulative,
            uint256 price1Cumulative,
            uint32 blockTimestamp
        ) = UniswapV2OracleLibrary.currentCumulativePrices(pair);
        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired

        // ensure that at least one full period has passed since the last update
        require(
            timeElapsed >= PERIOD,
            "ExampleOracleSimple: PERIOD_NOT_ELAPSED"
        );

        // overflow is desired, casting never truncates
        // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
        price0Average = FixedPoint.uq112x112(
            uint224((price0Cumulative - price0CumulativeLast) / timeElapsed)
        );
        price1Average = FixedPoint.uq112x112(
            uint224((price1Cumulative - price1CumulativeLast) / timeElapsed)
        );

        price0CumulativeLast = price0Cumulative;
        price1CumulativeLast = price1Cumulative;
        blockTimestampLast = blockTimestamp;
    }

    function update2() public {
        address _factory = IUniswapV2Router01(router).factory();
        address pair = IUniswapV2Factory(_factory).getPair(USDC, WETH);

        (
            uint256 price0Cumulative,
            uint256 price1Cumulative,
            uint32 blockTimestamp
        ) = UniswapV2OracleLibrary.currentCumulativePrices(pair);
        uint32 timeElapsed = blockTimestamp - blockTimestampLast2; // overflow is desired

        // ensure that at least one full period has passed since the last update
        require(
            timeElapsed >= PERIOD,
            "ExampleOracleSimple: PERIOD_NOT_ELAPSED"
        );

        // overflow is desired, casting never truncates
        // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
        price0Average2 = FixedPoint.uq112x112(
            uint224((price0Cumulative - price0CumulativeLast2) / timeElapsed)
        );
        price1Average2 = FixedPoint.uq112x112(
            uint224((price1Cumulative - price1CumulativeLast2) / timeElapsed)
        );

        price0CumulativeLast2 = price0Cumulative;
        price1CumulativeLast2 = price1Cumulative;
        blockTimestampLast2 = blockTimestamp;
    }

    address public immutable USDC;
    address public immutable WETH;
    address public immutable router;
    address public immutable TOKEN;
    uint256 public testAmountsIn;
    address public owner;
    uint8 _decimals;
    string _description;
    uint256 _version;
    bool _twapEnabled;
    // events
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    modifier onlyOwner() {
        require(msg.sender == owner, "oo");
        _;
    }

    function transaferOwnership(address newOwner) public onlyOwner {
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    constructor(
        address _token,
        address _usdt,
        address _weth,
        address _router
    ) {
        TOKEN = _token;
        USDC = _usdt;
        WETH = _weth;
        router = _router;
        testAmountsIn = 1 ether;
        owner = msg.sender;
        _decimals = 8;
        _description = "twap price feed 2";
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

    function setTwapEnable(bool _bEnabled) public onlyOwner {
        _twapEnabled = _bEnabled;
    }

    function setPeriod(uint256 _period) public onlyOwner {
        PERIOD = _period;
    }

    function decimals() external view override returns (uint8) {
        return _decimals;
    }

    function description() external view override returns (string memory) {
        return _description;
    }

    function version() external view override returns (uint256) {
        return _version;
    }

    function twapEnabled() external view returns (bool) {
        return _twapEnabled;
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
        if (_twapEnabled) {
            answer = getPriceTWAP();
        } else {
            answer = getPrice();
        }
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
        if (_twapEnabled) {
            answer = getPriceTWAP();
        } else {
            answer = getPrice();
        }
        startedAt = block.timestamp;
        updatedAt = block.timestamp;
        answeredInRound = uint80(block.number);
    }

    function getPrice() public view returns (int256) {
        address[] memory path = new address[](3);
        path[0] = TOKEN;
        path[1] = WETH;
        path[2] = USDC;
        uint256 amountIn = testAmountsIn;
        uint256[] memory amounts = IUniswapV2Router01(router).getAmountsOut(
            amountIn,
            path
        );
        uint256 _dec = _decimals + ERC20Interface(TOKEN).decimals();
        uint256 usdcDecimal = ERC20Interface(USDC).decimals();
        int256 price;
        if (_dec >= usdcDecimal) {
            price = int256(
                (amounts[2].mul(uint256(10**uint256(_dec - usdcDecimal)))).div(
                    testAmountsIn
                )
            );
        } else {
            price = int256(
                amounts[2].div(uint256(10**uint256(usdcDecimal - _dec))).div(
                    testAmountsIn
                )
            );
        }
        return price;
    }

    // you can get precise price after twice calls of update function
    function getPriceTWAP() public view returns (int256) {
        uint256 amountIn = testAmountsIn;
        uint256 amountOut1 = consult(TOKEN, amountIn);
        uint256 amountOut = consult2(WETH, amountOut1);
        uint256 _dec = _decimals + ERC20Interface(TOKEN).decimals();
        uint256 usdcDecimal = ERC20Interface(USDC).decimals();
        int256 price;
        if (_dec >= usdcDecimal) {
            price = int256(
                (amountOut.mul(uint256(10**uint256(_dec - usdcDecimal)))).div(
                    testAmountsIn
                )
            );
        } else {
            price = int256(
                amountOut.div(uint256(10**uint256(usdcDecimal - _dec))).div(
                    testAmountsIn
                )
            );
        }
        return price;
    }

    // note this will always return 0 before update has been called successfully for the first time.
    function consult(address token, uint256 amountIn)
        public
        view
        returns (uint256 amountOut)
    {
        (address token0, address token1) = UniswapV2Library.sortTokens(
            TOKEN,
            USDC
        );
        if (token == token0) {
            amountOut = price0Average.mul(amountIn).decode144();
        } else {
            require(token == token1, "ExampleOracleSimple: INVALID_TOKEN");
            amountOut = price1Average.mul(amountIn).decode144();
        }
    }

    function consult2(address token, uint256 amountIn)
        public
        view
        returns (uint256 amountOut)
    {
        (address token0, address token1) = UniswapV2Library.sortTokens(
            WETH,
            USDC
        );
        if (token == token0) {
            amountOut = price0Average2.mul(amountIn).decode144();
        } else {
            require(token == token1, "ExampleOracleSimple: INVALID_TOKEN");
            amountOut = price1Average2.mul(amountIn).decode144();
        }
    }
}
