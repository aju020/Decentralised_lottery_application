// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.5.0 < 0.9.0;

contract Lottery{
    
    address manager;//all the participant's money is credited to manager account
    address payable[] public participants;//since the money needs to be paid back to parti,its made payable
    address payable public winner;

    //next we assign that only manager can deploy the contract using msg.sender
    //msg.sender() becomes the sole person who controls the contract

    constructor(){
        manager=msg.sender;//global variable
    }

    receive() external payable{
        
        require(msg.value==1 ether,"Please pay 1 ether");//the next statement/transaction will be executed only if this condition is satisfied
        //to register the participants
        participants.push(payable(msg.sender)); //for paying amount to participant
        //special type of fun(receive) can be used only once in a contract and needs to be declared external

    }

    //to get balance of the manager account
    function getBalance() public view returns(uint){
        require(msg.sender==manager,"You are not the manager");
        return address(this).balance;
    }

    //now we need to generate a random number after registration ,done using keccak fun(hashing fun) which takes current block difficulty timestamp and parti length 
    function random() internal view returns(uint){ //its internal so noone outside contract can call it
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }
    //

    function selectWinner() public {
        require(msg.sender==manager);
        require(participants.length>=3);
        
        uint index = random() % participants.length;
        winner=participants[index];
        winner.transfer(getBalance());//transfering the managers money received to winner
        participants = new address payable[](0);//reset the participants
    }

    function allParticipants() public view returns(address payable[] memory){
        return participants;
    }

}