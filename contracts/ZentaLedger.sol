 ? Function 1: Add a new record to the ledger
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

    ? Function 3: View record details
    function getRecord(uint256 _id) public view returns (Record memory) {
        require(_id > 0 && _id <= recordCount, "Invalid record ID");
        return records[_id];
    }
}
// 
update
// 
