 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ZentaLedger
 * @dev A decentralized immutable ledger for storing and auditing digital records on-chain.
 */
contract Project {
    address public admin;
    uint256 public recordCount;

    struct Record {
        uint256 id;
        address creator;
        string dataHash;
        string description;
        uint256 timestamp;
        bool verified;
    }

    mapping(uint256 => Record) public records;

    event RecordAdded(uint256 indexed id, address indexed creator, string dataHash, string description);
    event RecordVerified(uint256 indexed id);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    // ✅ Function 1: Add a new record to the ledger
    function addRecord(string memory _dataHash, string memory _description) public {
        require(bytes(_dataHash).length > 0, "Data hash cannot be empty");
        require(bytes(_description).length > 0, "Description required");

        recordCount++;
        records[recordCount] = Record(
            recordCount,
            msg.sender,
            _dataHash,
            _description,
            block.timestamp,
            false
        );

        emit RecordAdded(recordCount, msg.sender, _dataHash, _description);
    }

    // ✅ Function 2: Verify a record (admin only)
    function verifyRecord(uint256 _id) public onlyAdmin {
        Record storage r = records[_id];
        require(!r.verified, "Record already verified");
        r.verified = true;

        emit RecordVerified(_id);
    }

    // ✅ Function 3: View record details
    function getRecord(uint256 _id) public view returns (Record memory) {
        require(_id > 0 && _id <= recordCount, "Invalid record ID");
        return records[_id];
    }
}
