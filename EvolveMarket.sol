/* SPDX-License-Identifier: MIT OR Apache-2.0 */
pragma solidity ^0.8.9;
import "./SafeMath.sol";
import "./Address.sol";
import "./Context.sol";
import "./Ownable.sol";
import "./ERC20.sol";
contract EvolveMarket is Context, Ownable{
    using SafeMath for uint256;
    using Address for address;
    uint public tokenIndex = 0;
    uint public tokenPriceWithUSD = 1000000000000000000;
    ERC20 public tokenMarket;
    mapping(uint => ERC20) public _tokenList;

    constructor(ERC20 _ercToken){
        tokenMarket = _ercToken;
    }

    function addNewToken(ERC20 _ERCToken) public onlyOwner returns (uint _tokenIndex) {
        _tokenIndex = tokenIndex;
        _tokenList[_tokenIndex] = _ERCToken;
        tokenIndex += 1;
    }

    function updateTokenPrice(uint _newPriceWithUSD) public onlyOwner returns(bool){
        tokenPriceWithUSD = _newPriceWithUSD;
        return true;
    }

    function multiply(uint256 a, uint256 b, uint decimals) private pure returns(uint256){
        uint result = (a*b)/(10**(decimals));
        return result;
    }

     function swapTokenToEvolve(uint256 _evolveAmount, uint256 _tokenIndex) public returns(bool){
        ERC20 currentToken = _tokenList[_tokenIndex];
        uint256 stableTokenAmount = multiply(_evolveAmount,tokenPriceWithUSD , 18);
        currentToken.transferFrom(_msgSender(), owner(), stableTokenAmount);
        tokenMarket.transferFrom(owner(),_msgSender(), _evolveAmount);
        return true;
    }


    

}