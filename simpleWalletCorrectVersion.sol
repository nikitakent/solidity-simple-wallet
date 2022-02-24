pragma solidity ^0.5.17;

import "./Owned.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract Allowance is Owned {
    event AllowanceChanged(address _forWho, address indexed _fromWhom, uint _oldAmount, uint newAmount);

    mapping (address => uint) public allowance; 

    function addAllowance(address _who, uint _amount) public onlyOwner{
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }

    modifier ownerOrAllowed(uint _amount){
        require(msg.sender == owner || allowance[msg.sender] >= _amount, "You do not have the required permissions to perform this operation.");
        _;
    }

    function reduceAllowance(address _who, uint _amount) internal {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who] - _amount);
        allowance[_who] =- (_amount);
    }
}

contract SimpleWallet is Allowance {

    event MoneyRecieved(address indexed _from, uint _amount);
    event MoneySent(address indexed _beneficiary, uint _amount);

    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
    // lowers allowance if the msg.sender is not the owner... why do this? 
    // owner can override allowance amount. Do we really want this?
        require(_amount <= address(this).balance, "There are not enough funds in the smart contract"); // why use the (this) notation...?
       if(msg.sender != owner){
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }
// FALL BACK FUNCTION
    function () external payable {
        emit MoneyRecieved(msg.sender, msg.value);
    }

}










// Notes: sending to fallback function can be a bit funny. First deploy, then enter value of ether, then press the 'transact' 
// button where under the 'Low level interactions' tab. 



// ************************************************************************ //
// ************************************************************************ //
// ************************************************************************ //
// ************************************************************************ //
// ************************************************************************ //

// import the ownable contract ....
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
// doesn't work because this uses an more advanced compiler. Import from file in the same folder...
// GET IN THE HABIT OF REGULARLY COMPILNG AND RUNNING!

// ************************************************************************ //
// // SECURE THE SMART CONTRACT: 
// constructor() public {
//     owner = msg.sender;
// }

// // CREATE MODIFIER ------- MODIFIER NOT USED IN THE SMART CONTRACT
// modifier onlyOwner() {
//     require(owner == msg.sender, "You are not allowed");
//     _;
// }

// ************************************************************************ //