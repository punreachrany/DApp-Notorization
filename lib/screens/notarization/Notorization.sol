pragma solidity ^0.5.0;


contract Notary {

  struct DocRecord{
      string signature;
      uint256 timestamp;
      bool isValue;
  }
  
  mapping(string => DocRecord) DocRecordMap;
  
  function getRecord(string memory _inputHash) public view returns(string memory, uint256, bool){
      string memory _signature = DocRecordMap[_inputHash].signature;
      uint256 _timestamp = DocRecordMap[_inputHash].timestamp;
      bool _isValue = DocRecordMap[_inputHash].isValue;
      
      return (_signature, _timestamp, _isValue);
  }
  
  function writeRecord(string memory _inputHash, string memory _signature) public {
      require(DocRecordMap[_inputHash].timestamp == 0);
      DocRecordMap[_inputHash].signature = _signature;
      DocRecordMap[_inputHash].timestamp = now;
      DocRecordMap[_inputHash].isValue = true;
  }
  
  function checkExistence(string memory _inputHash) public view returns (bool){
      if(DocRecordMap[_inputHash].isValue){
          return true;
      }else{
          return false;
      }
  }
  
  

}
