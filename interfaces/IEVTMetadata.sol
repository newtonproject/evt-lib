// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

interface IEVTMetadata {
    
    /**
     * @dev Returns the token description.
     */
	function description(uint256 tokenId) external view returns (string memory);

    /**
     * @dev Returns the token collection image.
     */
	function logo() external view returns (string memory);
		
    /**
     * @dev Returns the token collection from.
     */
    function from() external view returns (string memory);

    /**
     * @dev Returns the token tax.
     */
    function tax(uint256 tokenId) external view returns (uint);

    /**
     * @dev Returns the token collection external_url.
     */
    function external_url() external view returns (string memory);
}
