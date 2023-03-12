// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector {

    // Array to store NFTs
    string[] public kryptoBirdz;

    mapping(string => bool) _kryptoBirdzExists;

    function mint(string memory _kryptoBird) public {
        
        require(!_kryptoBirdzExists[_kryptoBird],
        'Error - kryptoBird already exists');

        // Deprecated:
        // uint _id = KryptoBirdz.push(_kryptoBird);
        // .push no longer returns length but a ref to the added element

        kryptoBirdz.push(_kryptoBird);
        uint _id = kryptoBirdz.length - 1;

        _mint(msg.sender, _id);
        //    ^global variable that's 1st address in Ganache

        _kryptoBirdzExists[_kryptoBird] = true;
    }

    constructor() ERC721Connector('KryptoBird', 'KBIRDZ') {
        
    }
}