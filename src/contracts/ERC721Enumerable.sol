// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is IERC721Enumerable, ERC721 {

    uint256[] private _allTokens;

    // Mapping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    // Mapping of owner to list of all owner token IDs
    mapping(address => uint256[]) private _ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    constructor() {
        _registerInterface(bytes4(keccak256('totalSupply(bytes4)')^
        keccak256('tokenByIndex(bytes4)')^
        keccak256('tokenOfOwnerByIndex(bytes4)')));
    }

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);

        _addTokensToAllTokenEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    // Add tokens to _allTokens array and set position of token indexes
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
        
        // _ownedTokensIndex[tokenId] set to address of _ownedTokens position
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;

        // Add address and token ID to _ownedTokens
        _ownedTokens[to].push(tokenId);
    }

    function tokenByIndex(uint256 index) public override view returns(uint256) {
        require(index < totalSupply(), 'Global index is out of bounds');
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint index) public override view returns(uint256) {
        require(index < balanceOf(owner), 'Global index is out of bounds');
        return _ownedTokens[owner][index];
    } 

    // Return total supply of _allTokens array
    function totalSupply() public override view returns(uint256) {
        return _allTokens.length;
    }
}