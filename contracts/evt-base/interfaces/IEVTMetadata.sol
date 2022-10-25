// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;
import "../IEVT.sol";

interface IEVTMetadata is IEVT, NRC7Metadata {	
    /// @notice tags for a collection of EVTs in this contract
    function from() external view returns (string memory);

    /// @notice Returns the Uniform Resource Identifier (URI) for the specified EVT tokenId.
    /// @dev Throws if `_tokenId` is not a valid EVT. URIs are defined in RFC3986. 
    ///  The URI may point to a JSON file or Base64 encode data that conforms to the
    ///  "NRC7 Metadata JSON Schema".
    /// @return The JSON formatted URI for the specified EVT tokenId
    function tokenURI(uint256 _tokenId) external view returns (string memory);

    /// @notice Returns the Uniform Resource Identifier (URI) for the storefront-level metadata for your contract.
    /// @dev This function SHOULD return the URI for this contract in JSON format, starting with
    ///  header `data:application/json;base64,`. 
    /// @return The JSON formatted URI of the current EVT contract
    function contractURI() external view returns (string memory);

    /// @notice Returns the Uniform Resource Identifier (URI) for the variable properties of specified EVT tokenId.
    /// @dev This function SHOULD return the URI for those properties in JSON format, starting with
    ///  header `data:application/json;base64,`. 
    /// @return The JSON formatted URI for the variable properties of specified EVT tokenId
    function variableURI(uint256 _tokenId) external view returns (string memory);

    /// @notice Returns the Uniform Resource Identifier (URI) for the encryption resources of specified EVT tokenId.
    /// @dev This function SHOULD return the URI for those resources in JSON format, starting with
    ///  header `data:application/json;base64,`. 
    /// @return The JSON formatted URI for the encryption resources of specified EVT tokenId
    function encryptionURI(uint256 _tokenId) external view returns (string memory);  
}