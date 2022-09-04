// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.12;

interface IUniswapPair {
    function token0() external view returns (address);
    function token1() external view returns (address);
    function swapFee() external view returns (uint32);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}