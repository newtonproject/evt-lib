# music

## Base

1. Imusic
2. EVT
3. ERC721Enumerable
4. ERC721URIStorage
5. Pausable
6. ERC721Burnable

## Deploy

| param           | type      | note                           |
| --------------- | --------- | ------------------------------ |
| name\_          | string    | token music name               |
| symbol\_        | string    | token music symbol             |
| properties      | string[]  | EVT property Names             |
| encryptedKeyIDs | bytes32[] | EVT encryptionKeyID            |
| baseURI\_       | string    | point to the EVT offchain data |

## Functions

```
pause()
unpause()
safeMint(to, amount)
safeMint(address to, string[] uris)
updateTokenURIStorage(uint256 tokenId, string memory uri)
updateStartTime(uint256 startTime_)
updateEndTime(uint256 endTime_)
updateBaseURI(baseURI_)
tokenURIStorage(uint256 tokenId)
isOwn(tokenId, addr)
hasPermission(uint256 tokenId, bytes32 encryptedKeyID, address licensee)
startTime()
endTime()
```

## Events

```
event Createmusic(tokenId)
event BaseURIUpdate(baseURI)
```

## Function

### pause()

Pause contract.

Requirements:

- onlyOwner

### unpause()

Restart contract.

Requirements:

- onlyOwner

### safeMint(address to, uint256 amount)

Batch mint music.

Requirements:

- onlyOwner

### safeMint(address to, string[] uris)

Batch mint music and set tokenURI.

Requirements:

- onlyOwner

### updateTokenURIStorage(uint256 tokenId, string uri)

Update Token URIStorage.See {IERC721Metadata-tokenURI}.

Requirements:

- onlyOwner

### updateStartTime(uint256 startTime\_)

Update `startTime`.

Requirements:

- onlyOwner

### updateEndTime(uint256 endTime\_)

Update `endTime`.

Requirements:

- onlyOwner

### updateBaseURI(string baseURI\_)

Update `baseURI`.

Requirements:

- onlyOwner

### tokenURIStorage(uint256 tokenId) -> string

Returns token URIStorage.See {IERC721Metadata-tokenURI}.

Requirements:

- `tokenId` must exist.

### isOwn(uint256 tokenId, address addr) -> bool

Returns whether `addr` own `tokenId`.

Requirements:

- `tokenId` must exist.

### hasPermission(uint256 tokenId, bytes32 encryptedKeyID, address licensee) -> bool

Returns whether have access to decrypt the music.

Requirements:

- must own this `tokenId`.
- `tokenId` must exist.
- current time must be within the copyright period.

### startTime() -> uint256

Returns `startTime`.

### endTime() -> uint256

Returns `endTime`.

## Event

### Createmusic(uint256 indexed tokenId)

Emitted when `tokenId` EVT is created.

### BaseURIUpdate(string baseURI)

Emitted when `baseURI` is updated.
