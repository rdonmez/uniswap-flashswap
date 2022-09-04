// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.12;

import "./IERC20.sol";   
import "./IUniswapPair.sol";
import "./IUniswapFactory.sol";

contract FlashQuery {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    function getInfoByTokens (address[] calldata _tokens) external view returns (string[3][] memory) {
        string[3][] memory result = new string[3][](_tokens.length);
        for (uint i = 0; i < _tokens.length; i++) {
            address account = _tokens[i];
            if(isContract(account)) {
                try IERC20(account).name() returns (string memory) {
                    result[i][0] = IERC20(account).name(); 
                } catch { result[i][0] = ""; } 
            
                try IERC20(account).symbol() returns (string memory) { 
                    result[i][1] = IERC20(account).symbol(); 
                } catch { result[i][1] = ""; }

                try IERC20(account).decimals() returns (uint8) { 
                    result[i][2] = uint32ToString(uint32(IERC20(account).decimals()));
                } catch { result[i][2] = ""; }
            }  else {
                result[i][0] = "";
                result[i][1] = "";
                result[i][2] = "";
            }
        }
        return result;
    } 

    function getReservesByPairs(IUniswapPair[] calldata _pairs) external view returns (uint256[3][] memory) {
        uint256[3][] memory result = new uint256[3][](_pairs.length);
        for (uint i = 0; i < _pairs.length; i++) {
            (result[i][0], result[i][1], result[i][2]) = _pairs[i].getReserves();
        }
        return result;
    }

    function getPairs(IUniswapFactory _factory, uint256 _start, uint256 _stop) external view returns (address[3][] memory)  {
        uint256 _allPairsLength = _factory.allPairsLength();
        if (_stop > _allPairsLength) {
            _stop = _allPairsLength;
        }
        require(_stop >= _start, "start cannot be higher than stop");
        uint256 _qty = _stop - _start;
        address[3][] memory result = new address[3][](_qty);
        for (uint i = 0; i < _qty; i++) {
            IUniswapPair _pair = IUniswapPair(_factory.allPairs(_start + i));
            result[i][0] = _pair.token0();
            result[i][1] = _pair.token1();
            result[i][2] = address(_pair);
        }
        return result;
    }
    
    function uint32ToString(uint32 value) public pure returns (string memory) {
       
        if (value == 0) {
            return "0";
        }
        uint256 temp = uint32(value);
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
 
    function addressToString(address addr, uint256 length) public pure returns (string memory) {
        uint256 value = uint256(uint160(addr));
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }
}