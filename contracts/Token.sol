//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20{
    constructor() ERC20("9GAG", "9GAG"){
        _mint(msg.sender,420690000000000*10**18);
    }
}