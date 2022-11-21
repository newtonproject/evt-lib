# Collection

## Base

1. ICollection
2. EVT
3. ERC721Enumerable
4. ERC721URIStorage
5. Pausable
6. ERC721Burnable

## Deploy

| param           | type      | note                           |
| --------------- | --------- | ------------------------------ |
| name\_          | string    | token collection name          |
| symbol\_        | string    | token collection symbol        |
| properties      | string[]  | EVT property Names             |
| encryptedKeyIDs | bytes32[] | EVT encryptionKeyID            |
| baseURI\_       | string    | point to the EVT offchain data |

```
pause()
unpause()
safeMint(to, amount)
safeMint(address to, string[] uris)
updateTokenURIStorage(uint256 tokenId, string memory uri)
updateBaseURI(baseURI_)
tokenURIStorage(uint256 collectionId)
isOwnCollection(collectionId, addr)
```

## Events

```
event CreateCollection(collectionId)
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

Batch mint collections.

Requirements:

- onlyOwner

### safeMint(address to, string[] uris)

Batch mint collections and set tokenURI.

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

### tokenURIStorage(uint256 collectionId) -> string

Returns token URIStorage.See {IERC721Metadata-tokenURI}.

Requirements:

- `collectionId` must exist.

### isOwnCollection(uint256 collectionId, address addr) -> bool

Returns whether `addr` own `collectionId`.

Requirements:

- `collectionId` must exist.

## Event

### CreateCollection(uint256 indexed collectionId)

Emitted when `collectionId` EVT is created.

### BaseURIUpdate(string baseURI)

Emitted when `baseURI` is updated.
