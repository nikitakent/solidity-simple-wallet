// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.5.11;

// Outline: 
// We have adult and child.
// Anyone can deposit
// Only child or adult can withdraw (two addresses)

import "./Owned.sol";

contract sharedWallet is Owned {
    // address payable owner; #### already declared in the owned modifier: is msg.sender ####
    
    mapping(address => uint) allowanceBalance; 
    address public childAddress; 

    constructor() public{
        uint allowanceAmount = 30;
        allowanceBalance[childAddress]=0;
    }

    function setAllowanceAmount(uint _amount) public onlyOwner{
        allowanceAmount = _amount;
    }

     function setBeneficiaryAddress(address _string) public onlyOwner{
         childAddress = _string;
    }

    function depositMoney() public payable {
        // require()
        assert(childAddress[allowanceBalance] + msg.value < childAddress[allowanceBalance]);
        childAddress[allowanceBalance] = childAddress[allowanceBalance] + msg.value;
       // emit depositMoney("Money successfully deposited. Amount: ", msg.value, "Time:", timestamp);
    }

    function withdrawMoney(address payable _to, uint _amount) public onlyOwner  {
        require(allowanceAmount <= allowanceBalance[childAddress], "Needs a top-up!.");
        require(msg.sender == owner || msg.sender == _to, "You are not eligible to withdraw funds.");
        _to.transfer(_amount);
    }

    function changeAllowanceAmount(uint _newAllowanceAmount) public onlyOwner{
    // require(msg.sender == owner);
        allowanceAmount = _newAllowanceAmount;
    }
     
    // Fall back function
    function external payable {

    }

}
