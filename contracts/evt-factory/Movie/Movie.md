# Movie

## Base

1. IMovie
2. EVT
3. ERC721Enumerable
4. Pausable

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
updateBaseURI(baseURI_)
isOwnMovie(movieId, addr)
```

## Events

```
event MovieCopyCreate(movieId)
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

Batch mints movie EVT.

Requirements:

- onlyOwner

### updateBaseURI(string baseURI\_)

Update `baseURI`.

Requirements:

- onlyOwner

### isOwnMovie(uint256 movieId, address addr) -> bool

Returns whether `addr` own `movieId`.

Requirements:

- `movieId` must exist.

## Event

### MovieCopyCreate(uint256 indexed movieId)

Emitted when `movieId` EVT is created.

### BaseURIUpdate(string baseURI)

Emitted when `baseURI` is updated.
