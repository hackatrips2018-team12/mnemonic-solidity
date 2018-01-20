pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract MnemonicVault is Ownable {

  struct Document {
    uint id;
    string name;
    string key;  
    address issuer;
    string issuerName;
    uint issueTime;
    uint expirationTime;
    string offchainUrl;
  }

  struct Claim {
    address claimer;
    string claimerName;
    uint claimTime;
  }

  enum GrantRequestStatus { Pending, Accepted, Rejected }

  struct GrantRequest {
    address issuer;
    string key;
    address requestor;
    string requestorName;
    uint requestTime;
    uint requestExpirationTime;
    GrantRequestStatus status;
  }

  uint docIndex;
  mapping(address => mapping(string => Document)) documents;
  mapping(address => mapping(string => GrantRequest)) grants;
  mapping(address => mapping(string => Claim)) claims;  
  mapping(uint => Document) allDocuments;


  function MnemonicVault() public {
    docIndex = 0;
  }


  function getTotalDocuments() view
      public
      onlyOwner()
      returns (uint _totalDocuments)
  {
    return docIndex;
  }


  function getDocument(uint _id) view
      public
      onlyOwner()
      returns (
        string _name,
    	string _key, 
    	address _issuer,
    	string _issuerName,
    	uint _issueTime,
    	uint _expirationTime,
    	string _offchainUrl)
  {
    Document memory doc = allDocuments[_id];
    return (doc.name,
    	    doc.key,
	    doc.issuer,
	    doc.issuerName,
	    doc.issueTime,
	    doc.expirationTime,
	    doc.offchainUrl);
  }


  function retrieveDocument(string _key) view
      public
      onlyOwner()
      returns (
        uint _id,
        string _name,
    	address _issuer,
    	string _issuerName,
    	uint _issueTime,
    	uint _expirationTime,
    	string _offchainUrl)
  {
    Document memory doc = documents[_issuer][_key];
    return (doc.id,
            doc.name,
	    doc.issuer,
	    doc.issuerName,
	    doc.issueTime,
	    doc.expirationTime,
	    doc.offchainUrl);
  }


  function addDocument(
        string _name,
    	string _key,
    	string _issuerName,
    	uint _expirationTime,
    	string _offchainUrl)
	public
  {
    require (_expirationTime > now);

    address issuer = msg.sender;
    uint issueTime = now;
    docIndex += 1;
    
    Document memory doc = Document(
      docIndex,
      _name,
      _key,
      issuer,
      _issuerName,
      issueTime,
      _expirationTime,
      _offchainUrl);

    documents[issuer][_key] = doc;
    allDocuments[docIndex] = doc;    
  }

}