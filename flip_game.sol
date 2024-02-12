// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

error SeedTooShort();

contract Coinflip is Ownable {
    
    string public seed;

    constructor() Ownable(msg.sender) {
        seed = "Default seed string";
    }

    function userInput(uint8[10] calldata Guesses) external view returns(bool) {
        uint8[10] memory generatedGuesses = getFlips();
        for (uint i = 0; i < 10; i++) {
            if (Guesses[i] != generatedGuesses[i]) {
                return false;
            }
        }
        retuFrn true;
    }

    function seedRotation(string memory NewSeed) public onlyOwner {
        bytes memory seedBytes = bytes(NewSeed);
        uint seedLength = seedBytes.length;

        if (seedLength < 10) {
            revert SeedTooShort();
        }

        seed = NewSeed;
    }

    function getFlips() public view returns(uint8[10] memory) {
        bytes memory stringInBytes = bytes(seed);
        uint seedLength = stringInBytes.length;

        uint8[10] memory results;

        uint interval = seedLength / 10;
        for (uint i = 0; i < 10; i++) {
            uint randomNum = uint(keccak256(abi.encodePacked(stringInBytes[i * interval], block.timestamp)));
            results[i] = randomNum % 2 == 0 ? 1 : 0;
        }

        return results;
    }
}

