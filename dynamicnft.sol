// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DynamicMetadataNFT {
    uint256 public tokenCounter;
    mapping(uint256 => string) private tokenMetadata;
    mapping(uint256 => address) public tokenOwners;

    event Mint(address indexed owner, uint256 indexed tokenId);
    event MetadataUpdated(uint256 indexed tokenId, string metadata);

    // Mint a new NFT (dynamically assigning metadata on mint)
    function mint() public {
        tokenCounter++;
        uint256 newTokenId = tokenCounter;
        tokenOwners[newTokenId] = msg.sender;

        // Default metadata can be a placeholder or something dynamically generated
        tokenMetadata[newTokenId] = string(abi.encodePacked("https://api.example.com/metadata/", uint2str(newTokenId)));

        emit Mint(msg.sender, newTokenId);
    }

    // Update metadata of a given token ID (can be done by the owner of the token)
    function updateMetadata(uint256 tokenId, string memory newMetadata) public {
        require(msg.sender == tokenOwners[tokenId], "Only the owner can update the metadata");

        tokenMetadata[tokenId] = newMetadata;
        emit MetadataUpdated(tokenId, newMetadata);
    }

    // Get metadata for a specific token
    function getMetadata(uint256 tokenId) public view returns (string memory) {
        return tokenMetadata[tokenId];
    }

    // Convert uint256 to string for metadata (helper function)
    function uint2str(uint256 _i) private pure returns (string memory str) {
        if (_i == 0) {
            return "0";
        }
        uint256 temp = _i;
        uint256 length;
        while (temp != 0) {
            length++;
            temp /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 index = length - 1;
        while (_i != 0) {
            bstr[index--] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        str = string(bstr);
    }
}
