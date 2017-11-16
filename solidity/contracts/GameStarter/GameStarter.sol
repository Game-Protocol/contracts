pragma solidity ^0.4.15;

import '../TokenHolder.sol';
import './Project.sol';


contract GameStarter is TokenHolder {

    uint activeProjects = 0;
    Project[] public projects;

    event ProjectAdded(address indexed creator, address project);

    function GameStarter() {

    }

    function CreateProject(bool isFixed, string title, string desc, string website, uint256 fundingGoal) {
        Project p = new Project(msg.sender, isFixed, title, desc, website, fundingGoal);
        projects.push(p);
        activeProjects = activeProjects + 1;
    }
}