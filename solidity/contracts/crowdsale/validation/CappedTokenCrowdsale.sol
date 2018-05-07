pragma solidity ^0.4.21;

import "../../math/SafeMath.sol";
import "../Crowdsale.sol";


/**
 * @title CappedCrowdsale
 * @dev Crowdsale with a limit for total contributions.
 */
contract CappedTokenCrowdsale is Crowdsale {
    using SafeMath for uint256;

    uint256 public tokenCap;

    /**
    * @dev Constructor, takes maximum amount of tokens issued in the crowdsale.
    * @param _tokenCap Max amount of wei to be contributed
    */
    constructor(uint256 _tokenCap) public {
        require(_tokenCap > 0);
        tokenCap = _tokenCap;
    }

    /**
    * @dev Checks whether the cap has been reached. 
    * @return Whether the cap was reached
    */
    function tokenCapReached() public view returns (bool) {
        return tokensAllocated >= tokenCap;
    }

    /**
    * @dev Extend parent behavior requiring purchase to respect the funding cap.
    * @param _beneficiary Token purchaser
    * @param _weiAmount Amount of wei contributed
    * @param _tokenAmount Amount of tokens allocated
    */
    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount, uint256 _tokenAmount) internal {
        super._preValidatePurchase(_beneficiary, _weiAmount, _tokenAmount);
        require(tokensAllocated.add(_tokenAmount) <= tokenCap);
    }
}