//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20{
    constructor() ERC20("Token", "TOKEN"){
        _mint(msg.sender,1000000000*10**18);
    }
}