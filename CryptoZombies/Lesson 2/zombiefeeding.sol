pragma solidity >=0.5.0 <=0.7.0;

import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {
   //Will give zombie ability to feed / multiply
  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]);  //check the one feeding is the owner
    Zombie storage myZombie = zombies[_zombieId];     //Get zombie DNA and store it to blockchain
    //Feeding function below
    function testDnaSplicing() public {
      _targetDna = _targetDna % dnaModulus //Last 16 digits only
      uint newDna = (myZombie.dna + _targetDna ) / 2; //set new DNA to avg of target dna and myzombie dna (use .dna for accessing struct info)
      _createZombie("NoName", newDna);

    }
  }

}
