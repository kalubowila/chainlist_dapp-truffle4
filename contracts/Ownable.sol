pragma solidity ^0.4.18;

contract Ownable{
  //state variable
  address owner;

  modifier onlyOwner(){
    require(msg.sender == owner);
    _;
  }

  constructor() public{
    owner = msg.sender;
  }
}
