pragma solidity ^0.4.15;

import '../TokenHolder.sol';
import './Project.sol';


contract GameStarter is TokenHolder {

    string public version = "0.1";
    uint public activeProjects = 0;
    address[] public projects;

    event ProjectAdded(address indexed creator, address project);

    function GameStarter() {

    }
    
    function createProject(bool _isFixed, string _title, string _category, string _description, string _website, uint256 _fundingGoal) {
        address p = new Project(msg.sender, _isFixed, _title,_category, _description, _website, _fundingGoal);
        projects.push(p);
        activeProjects = activeProjects + 1;
        ProjectAdded(msg.sender, p);
    }
}