# Name of Contract：Movie

## Base

1. IMovie
2. EVT
3. ERC721Enumerable

## Deploy

| param           | type      | note                           |
| --------------- | --------- | ------------------------------ |
| name\_          | string    | token collection name          |
| symbol\_        | string    | token collection symbol        |
| properties      | string[]  | EVT property Names             |
| encryptedKeyIDs | bytes32[] | EVT encryptionKeyID            |
| baseURI\_       | string    | point to the EVT offchain data |

## Functions

```
safeMint to, amount)
updateBaseURI(baseURI_)
function isOwnerMovie(movieId, addr)
```

## Events

```
event MovieCopyCreate(movieId)
event BaseURIUpdate(baseURI)
```

## Function

### safeMint(address to, uint256 amount)

batch mints movie EVT.

Requirements:

- onlyOwner

### updateBaseURI(string baseURI\_)

update `baseURI`.

Requirements:

- onlyOwner

### isOwnerMovie(uint256 movieId, address addr) -> bool

Returns whether `addr` own `movieId`.

Requirements:

- `movieId` must exist.

## Event

### MovieCopyCreate(uint256 indexed movieId)

Emitted when `movieId` EVT is created.

### BaseURIUpdate(string baseURI)

Emitted when `baseURI` is updated.
