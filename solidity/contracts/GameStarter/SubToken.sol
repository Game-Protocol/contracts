pragma solidity ^0.4.15;

import '../ERC20Token.sol';

contract SubToken is ERC20Token {


    
    function getPurchaseReturn(uint256 _amount)
        public
        constant
        returns (uint256 returnAmount)
    {

    }

    function getSaleReturn(uint256 _amount)
        public
        constant
        returns (uint256 returnAmount)
    {

    }

    function buy(uint256 _amount)
        public
        returns (bool success)
    {
        balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], _amount);
        return true;
    }

    function sell(uint256 _amount)
        public
        returns (bool success)
    {
        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _amount);
        return true;
    }
    
}