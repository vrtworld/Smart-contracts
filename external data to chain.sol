pragma solidity ^0.4.20; 

contract Registry{
    address public owner;
    string[] public regedits;
    
    event ChangeOwnership(address oldOwner, address newOwner);
    event RegisterNewEntry(string item);
    
    function Registry()public{
        // Setup the owner and wallet
        owner = msg.sender;
    }
    
    function changeOwnership(address newOwner)public returns(bool){
        // Setup the owner and wallet
        require(msg.sender == owner);   
        owner = newOwner;
        newOwner = address(0);
         ChangeOwnership(msg.sender,owner);
        return true;
    }

    function addRegEntry(string newEntry) public returns(uint){
        // Only the owner can do this
        require(msg.sender == owner);       
        regedits.push(newEntry);
         RegisterNewEntry(newEntry);
        return regedits.length;
    }
}
