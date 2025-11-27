// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title ZentaLedger
 * @notice Immutable on-chain ledger for recording entries with admin-controlled access.
 * @dev Each entry stores ID, author, category, data hash, and timestamp.
 */
contract ZentaLedger {

    address public admin;
    uint256 public entryCount;

    struct LedgerEntry {
        uint256 id;
        address author;
        string category;
        string dataHash;
        uint256 timestamp;
    }

    mapping(uint256 => LedgerEntry) public entries;
    mapping(address => uint256[]) public userEntries;

    event EntryRecorded(uint256 indexed id, address indexed author, string category, string dataHash);
    event AdminChanged(address indexed oldAdmin, address indexed newAdmin);

    modifier onlyAdmin() {
        require(msg.sender == admin, "ZentaLedger: NOT_ADMIN");
        _;
    }

    modifier entryExists(uint256 id) {
        require(id > 0 && id <= entryCount, "ZentaLedger: ENTRY_NOT_FOUND");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function recordEntry(string calldata category, string calldata dataHash) external onlyAdmin returns (uint256) {
        require(bytes(dataHash).length > 0, "ZentaLedger: EMPTY_HASH");

        entryCount++;
        entries[entryCount] = LedgerEntry({
            id: entryCount,
            author: msg.sender,
            category: category,
            dataHash: dataHash,
            timestamp: block.timestamp
        });

        userEntries[msg.sender].push(entryCount);

        emit EntryRecorded(entryCount, msg.sender, category, dataHash);
        return entryCount;
    }

    function getEntry(uint256 id) external view entryExists(id) returns (LedgerEntry memory) {
        return entries[id];
    }

    function getUserEntries(address user) external view returns (uint256[] memory) {
        return userEntries[user];
    }

    function changeAdmin(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "ZentaLedger: ZERO_ADMIN");
        emit AdminChanged(admin, newAdmin);
        admin = newAdmin;
    }
}
