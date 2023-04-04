//SPDX-License-Identifier: LICENSED

pragma solidity ^0.7.0;
import "../interfaces/AggregatorV3Interface.sol";
import "../interfaces/ERC20Interface.sol";
import "../libraries/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Swapper/satin/interfaces/IBasePair.sol";
import "../Swapper/satin/interfaces/IBaseV1Router01.sol";

contract SatinTwapPriceFeed is AggregatorV3Interface, Ownable {
    using SafeMath for uint256;
    address public immutable router;
    address public immutable USDC;
    address public immutable TOKEN;
    bool public stable;
    uint256 public testAmountsIn;
    uint8 _decimals;
    string _description;
    uint256 _version;

    // events

    constructor(address _token, address _usdt, address _router) {
        TOKEN = _token;
        USDC = _usdt;
        stable = false;
        router = _router;
        _decimals = 8;
        _description = "twap price feed for satin";
        _version = 1;
        testAmountsIn = 1 ether;
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

    function setStable(bool _stable) public onlyOwner {
        stable = _stable;
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
    function getRoundData(
        uint80 _roundId
    )
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

    // function getPrice() public view returns (int256) {
    //     address[] memory path = new address[](3);
    //     path[0] = TOKEN;
    //     path[1] = WETH;
    //     path[2] = USDC;
    //     uint256 amountIn = testAmountsIn;
    //     uint256[] memory amounts = IUniswapV2Router01(router).getAmountsOut(
    //         amountIn,
    //         path
    //     );
    //     uint256 _dec = _decimals + ERC20Interface(TOKEN).decimals();
    //     uint256 usdcDecimal = ERC20Interface(USDC).decimals();
    //     int256 price;
    //     if (_dec >= usdcDecimal) {
    //         price = int256(
    //             (amounts[2].mul(uint256(10**uint256(_dec - usdcDecimal)))).div(
    //                 testAmountsIn
    //             )
    //         );
    //     } else {
    //         price = int256(
    //             amounts[2].div(uint256(10**uint256(usdcDecimal - _dec))).div(
    //                 testAmountsIn
    //             )
    //         );
    //     }
    //     return price;
    // }

    function getPrice() public view returns (int256) {
        address poolAddress = IBaseV1Router01(router).pairFor(
            TOKEN,
            USDC,
            stable
        );
        uint[] memory prices = IBaseV1Pair(poolAddress).prices(
            TOKEN,
            testAmountsIn,
            1
        );

        uint256 quoteAmount = prices[0];

        uint256 _dec = _decimals + ERC20Interface(TOKEN).decimals();
        uint256 usdcDecimal = ERC20Interface(USDC).decimals();
        int256 price;
        if (_dec >= usdcDecimal) {
            price = int256(
                (quoteAmount.mul(uint256(10 ** uint256(_dec - usdcDecimal))))
                    .div(testAmountsIn)
            );
        } else {
            price = int256(
                quoteAmount.div(uint256(10 ** uint256(usdcDecimal - _dec))).div(
                    testAmountsIn
                )
            );
        }
        return price;
    }
}
