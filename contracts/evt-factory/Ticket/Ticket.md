# Ticket

## Base

1. ITicket
2. EVT
3. ERC721Enumerable
4. Pausable

## Deploy

| param            | type      | note                           |
| ---------------- | --------- | ------------------------------ |
| name\_           | string    | token collection name          |
| symbol\_         | string    | token collection symbol        |
| properties       | string[]  | EVT property Names             |
| encryptedKeyIDs  | bytes32[] | EVT encryptionKeyID            |
| baseURI\_        | string    | point to the EVT offchain data |
| movieAddr\_      | address   | movie contract address         |
| startTime\_      | uint256   | film release date              |
| endTime\_        | uint256   | film off the screen date       |
| ticketDuration\_ | uint256   | valid duration of the ticket   |

## Functions

```
pause()
unpause()
updateBaseURI(string baseURI_)
updateEndTime(uint256 _endTime)
updateTicketDuration(uint256 ticketDuration_)
updatePayee(address payee_)
getPayee()
withdraw()
safeMint(address to, uint256 amount, uint256 movieId)
checkTicket(uint256 ticketId)
commonInfo()
ticketInfo(uint256 ticketId)
```

```
movieAddr()
startTime()
endTime()
ticketDuration()
```

## Events
```
EventCreateTicket(uint256 indexed ticketId)
EventTicketCheck(uint256 indexed ticketId, uint256 startTime)
EndTimeUpdate(uint256 endTime)
TicketDurationUpdate(uint256 ticketDuration)
BaseURIUpdate(string baseURI)
PayeeUpdate(address payee)
```

## Function
### pause()

pause contract

Requirements:

- onlyOwner

### unpause()

restart contract

Requirements:

- onlyOwner

### updateBaseURI(string baseURI\_)

update `baseURI`.

Requirements:

- onlyOwner