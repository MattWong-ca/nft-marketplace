// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';

/*
    Minting function
    1. NFT to point to an address
    2. Keep track of token IDs
    3. Keep track of token owner addresses to token IDs (mapping)
    4. Keep track of how many tokens an owner address has
    5. Create an event that emits a transfer log
*/

contract ERC721 is ERC165, IERC721 {

    // Mapping from token ID to owner
    mapping(uint256 => address) private _tokenOwner;

    // Mapping from owner to number of owned tokens
    mapping(address => uint256) private _OwnedTokensCount;

    // Mapping from token ID to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^
        keccak256('ownerOf(bytes4)')^
        keccak256('transferFrom(bytes4)')));
    }

        function balanceOf(address _owner) public override view returns(uint256) {
            require(_owner != address(0), 'Owner query for non-existent token');
            return _OwnedTokensCount[_owner];
        }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT

    function ownerOf(uint256 _tokenId) public override view returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'Owner query for non-existent token');
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns(bool) {
        // Sets address of NFT owner to check the mapping
        // of the address from tokenOwner at the tokenId
        address owner = _tokenOwner[tokenId];
        // Return truthiness that address isn't zero
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        // Requires that address isn't zero
        require(to != address(0), 'ERC721: minting to the zero address');
        // Requires token doesn't already exist
        require(!_exists(tokenId), 'ERC721: token already minted');
        // Adding new address with a token ID for minting
        _tokenOwner[tokenId] = to;
        // Keeping track of each address that is minting and adding one
        _OwnedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        
        require(_to != address(0), 'Error - ERC721 Transfer to the zero address');
        require(ownerOf(_tokenId) == _from, 'Trying to transfer a token the address does not own');

        _OwnedTokensCount[_from] -= 1;
        _OwnedTokensCount[_to] += 1;
        
        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);

    }

    function transferFrom(address _from, address _to, uint256 _tokenId) override public {
        _transferFrom(_from, _to, _tokenId);
    }
    
}