// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title ZentaLedger
 * @notice A decentralized immutable ledger for storing and verifying digital records on-chain.
 *         Provides transparency, authenticity, and auditability for institutional and enterprise use.
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
    event RecordVerified(uint256 indexed id, address indexed verifier);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /**
     * @notice Add a new record to the ledger
     * @param _dataHash Unique hash of the data
     * @param _description Short description of the record
     */
    function addRecord(string memory _dataHash, string memory _description) external {
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

    /**
     * @notice Verify an existing record (admin only)
     * @param _id Record ID
     */
    function verifyRecord(uint256 _id) external onlyAdmin {
        require(_id > 0 && _id <= recordCount, "Invalid record ID");
        Record storage r = records[_id];
        require(!r.verified, "Record already verified");

        r.verified = true;
        emit RecordVerified(_id, msg.sender);
    }

    /**
     * @notice Get a record's details
     * @param _id Record ID
     * @return Record struct containing record details
     */
    function getRecord(uint256 _id) external view returns (Record memory) {
        require(_id > 0 && _id <= recordCount, "Invalid record ID");
        return records[_id];
    }
}
