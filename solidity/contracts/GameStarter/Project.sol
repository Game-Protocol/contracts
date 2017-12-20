pragma solidity ^0.4.15;

import '../TokenHolder.sol';


contract Project is TokenHolder {

    bool public isFixed = false;
    string public title = "";
    string public category;
    string public description = "";
    string public website = "";
    uint256 public fundingGoal = 0;
    uint256 public raised;

    uint public backerCount = 0;
    mapping  (address => uint256) public backers;

    function Project(address _creator, bool _isFixed, string _title, string _category, string _description, string _website, uint256 _fundingGoal) {
        owner = _creator;
        isFixed = _isFixed;
        title = _title;
        category = _category;
        description = _description;
        website = _website;
        fundingGoal = _fundingGoal;
    }
}
