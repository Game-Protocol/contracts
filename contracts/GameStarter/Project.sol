pragma solidity ^0.4.15;

import '../TokenHolder.sol';


contract Project is TokenHolder {

    struct Reward {
        uint256 pledgeAmount;
        bool isLimitedAvailability;
        uint availability;
        string description;
    }

    address public creator;
    bool public isFixed = false;
    string public title = "";
    string public category;
    string public description = "";
    string public website = "";
    uint256 public fundingGoal = 0;
    uint256 public raised;
    uint public backerCount;
    Reward[] public rewards;
    mapping  (address => uint256) public backers;


    function Project(address _creator, bool _isFixed, string _title, string _desc, string _website, uint256 _fundingGoal) {
        owner = creator;
    }
}
