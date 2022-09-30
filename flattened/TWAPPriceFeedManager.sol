// File contracts/CustomPriceFeed/TWAPPriceFeedManager.sol

//SPDX-License-Identifier: LICENSED

pragma solidity ^0.7.0;

interface IUpdate {
    function update() external;
}

contract TWAPPriceFeedManager {
    address[] public allPriceFeeds;
    mapping(address => bool) public priceFeedEnable;
    address public owner;
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

    constructor() {
        owner = msg.sender;
    }

    function addPriceFeed(address priceFeed) public onlyOwner {
        for (uint256 i = 0; i < allPriceFeeds.length; i++) {
            require(allPriceFeeds[i] != priceFeed, "maa");
        }
        allPriceFeeds.push(priceFeed);
        priceFeedEnable[priceFeed] = true;
    }

    function enablePriceFeed(address priceFeed, bool bEnable) public onlyOwner {
        priceFeedEnable[priceFeed] = bEnable;
    }

    function update() public {
        for (uint256 i = 0; i < allPriceFeeds.length; i++) {
            address addr = allPriceFeeds[i];
            if (priceFeedEnable[addr]) {
                IUpdate(addr).update();
            }
        }
    }
}
