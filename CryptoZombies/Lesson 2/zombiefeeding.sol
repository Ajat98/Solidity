pragma solidity >=0.5.0 <=0.7.0;

import "./zombiefactory.sol";

//KittyInterface contract 
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

  //cryptokitties contract address
  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  //intialize kittyContract using ckAddress from above
  KittyInterface kittyContract = KittyInterface(ckAddress);

  //Will give zombie ability to feed / multiply
  //Modified to include species and store in memory
  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
    require(msg.sender == zombieToOwner[_zombieId]);  //check the one feeding is the owner
    Zombie storage myZombie = zombies[_zombieId];     //Get zombie DNA and store it to blockchain
    _targetDna = _targetDna % dnaModulus; //Last 16 digits only
    uint newDna = (myZombie.dna + _targetDna ) / 2; //set new DNA to avg of target dna and myzombie dna (use .dna for accessing struct info)

    //If statement to compare hashes, use abi.encodePacked to pass to keccak since strings can't be passed directly.
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      //Replace last 2 digits of DNA with 9, e.g. if newDna is 334455, then newDna % 100 is 334400 so adding 99 gives us 334499
      newDna = newDna - newDna % 100 + 99; 
    }
    _createZombie("NoName", newDna);
  }

    //Create feedOnKitty function
    function feedOnKitty(uint _zombieId, uint _kittyId) public {
      uint kittyDna;
      (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
      
      //modified func call to include "kitty" in parameters
      feedAndMultiply(_zombieId, kittyDna, "kitty"); 
    }

}
