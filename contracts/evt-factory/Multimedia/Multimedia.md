# Multimedia

## Base

1. IMultimedia
2. EVT
3. ERC721Enumerable
4. ERC721URIStorage
5. Pausable
6. ERC721Burnable

## Deploy

| param           | type      | note                           |
| --------------- | --------- | ------------------------------ |
| name\_          | string    | token multimedia name          |
| symbol\_        | string    | token multimedia symbol        |
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
updateBaseURI(baseURI_)
tokenURIStorage(uint256 tokenId)
isOwn(tokenId, addr)
```

## Events

```
event CreateMultimedia(tokenId)
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

Batch mint multimedias.

Requirements:

- onlyOwner

### safeMint(address to, string[] uris)

Batch mint multimedias and set tokenURI.

Requirements:

- onlyOwner

### updateTokenURIStorage(uint256 tokenId, string uri)

Update Token URIStorage.See {IERC721Metadata-tokenURI}.

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

## Event

### CreateMultimedia(uint256 indexed tokenId)

Emitted when `tokenId` EVT is created.

### BaseURIUpdate(string baseURI)

Emitted when `baseURI` is updated.
