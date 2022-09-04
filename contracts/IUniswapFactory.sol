// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.12;

abstract contract IUniswapFactory  {
    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;
    function swapFee() virtual external view returns (uint32);
    function getPairFees(address) virtual external view returns (uint256);
    function FEE_RATE_DENOMINATOR() virtual external view returns (uint256);
    function allPairsLength() external view virtual returns (uint);
}