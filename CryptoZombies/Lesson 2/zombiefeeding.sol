pragma solidity >=0.5.0 <=0.7.0;

import "./zombiefactory.sol";

//add KittyInterface here
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {

  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  //intialize kittyContract using ckAddress from above
  KittyInterface kittyContract = KittyInterface(ckAddress);

  //Will give zombie ability to feed / multiply
  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]);  //check the one feeding is the owner
    Zombie storage myZombie = zombies[_zombieId];     //Get zombie DNA and store it to blockchain
    _targetDna = _targetDna % dnaModulus; //Last 16 digits only
    uint newDna = (myZombie.dna + _targetDna ) / 2; //set new DNA to avg of target dna and myzombie dna (use .dna for accessing struct info)
    _createZombie("NoName", newDna);
  }

    //Create feedOnKitty function
    function feedOnKitty(uint _zombieId, uint _kittyId) public {
      uint kittyDna;
      (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
      feedAndMultiply(_zombieId, kittyDna);
    }

}
