pragma solidity ^0.4.15;

import '../ERC20Token.sol';

contract SubToken is ERC20Token {

    // Reserve struct
    struct Reserve {
        uint256 virtualBalance;         // virtual balance
        uint32 ratio;                   // constant reserve ratio (CRR), represented in ppm, 1-1000000
        bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
        bool isPurchaseEnabled;         // is purchase of the smart token enabled with the reserve, can be set by the owner
        bool isSet;                     // used to tell if the mapping element is defined
    }

    Reserve public reserve;

    // add a reserve for changing from gpt to subtoken
    
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