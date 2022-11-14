// // SPDX-License-Identifier: GPL-3.0
// pragma solidity ^0.8.3;

// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";
// import "../../evt-base/EVT.sol";
// import "./ISecureTicket.sol";
// import "../Movie/ISecureMovie.sol";

// contract SecurTicket is ISecureTicket, EVT {
//     using Counters for Counters.Counter;
//     using Strings for uint256;
//     using EnumerableSet for EnumerableSet.UintSet;

//     Counters.Counter private _ticketIdCounter;

//     // Mapping from owner to set of TicketId
//     mapping(address => EnumerableSet.UintSet) private _ownerToTicketId;

//     ISecureMovie public movieContract;
//     uint256 public movieDuration;
//     uint256 public tichketDuration;
//     uint256 startTime;
//     string public uri;
//     address public payee;


//     constructor(
//         string memory name_,
//         string memory symbol_,
//         string[] memory properties,
//         bytes32[] memory encryptedKeyIDs,
//         string memory uri_,
//         address movieAddr,
//         uint256 startTime_,
//         uint256 duration_,
//         uint256 checkDuration_
//     ) EVT(name_, symbol_, properties, encryptedKeyIDs, uri_) {
//         movieContract = ISecureMovie(movieAddr);
//         uri = uri_;
//         duration = duration_;
//         checkDuration = checkDuration_;
//         startTime = startTime_;
//         payee = owner();
//     }

//     modifier onlyMovieOwner(uint256 movieId) {
//         require(
//             movieContract.isOwnerMovie(movieId, msg.sender),
//             "not movie owner"
//         );
//         _;
//     }

//     //onlyOwner
//     //onlyOwner
//     //onlyOwner
//     function updateDefaultURI(string memory _uri) public onlyOwner {
//         uri = _uri;

//         emit DefaultURIUpdate(_uri);
//     }

//     function updateDuration(uint256 _duration) public onlyOwner {
//         duration = _duration;

//         emit DurationUpdate(_duration);
//     }

//     function updateCheckDuration(uint256 _checkDuration) public onlyOwner {
//         checkDuration = _checkDuration;

//         emit CheckDurationUpdate(_checkDuration);
//     }

//     function updatePayee(address _payee) public onlyOwner {
//         require(_payee != address(0), "Invalid address");
//         payee = _payee;

//         emit PayeeUpdate(_payee);
//     }

//     //onlyMovieOwner
//     //onlyMovieOwner
//     //onlyMovieOwner
//     function safeMint(
//         address to,
//         uint256 amount,
//         uint256 movieId
//     ) public payable onlyMovieOwner(movieId) {
//         for (uint256 i = 0; i < amount; ++i) {
//             uint256 ticketId = _ticketIdCounter.current();
//             _ticketIdCounter.increment();
//             _safeMint(to, ticketId);
//             setDynamicProperty(ticketId, "movieId", movieId.toString());
//         }
//     }

//     //onlyTicketOwner
//     //onlyTicketOwner
//     //onlyTicketOwner
//     function watch(uint256 ticketId) public view returns (bool) {
//         require(msg.sender == ownerOf(ticketId), "not ticket owner");
//         require(block.timestamp > startTime && block.timestamp < startTime+duration);
//         if(getDynamicProperty(ticketId,"checkStartTime"));
//         return true;
//     }

//     //public
//     //public
//     //public
//     function withdraw() public {
//         Address.sendValue(payable(payee), address(this).balance);
//     }

//     function supportsInterface(bytes4 interfaceId)
//         public
//         view
//         virtual
//         override(IERC165, EVT)
//         returns (bool)
//     {
//         return super.supportsInterface(interfaceId);
//     }
// }
