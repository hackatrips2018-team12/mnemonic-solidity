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

  enum GrantRequestStatus { PENDING, GRANTED, REJECTED }

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
  mapping(address => mapping(address => mapping(string => GrantRequest))) grants;
  mapping(address => mapping(string => Claim)) claims;  
  mapping(uint => Document) allDocuments;

  event GrantRequested(address _issuer, string _key, address _requestor, string _requestorName);
  event GrantAccepted(address _issuer, string _key, address _requestor);
  event GrantRejected(address _issuer, string _key, address _requestor);  
 
  modifier onlyWithGrant(address _issuer, string _key) {
    GrantRequest storage grant = grants[msg.sender][_issuer][_key];
    require(grant.status == GrantRequestStatus.GRANTED);
    _;
  }


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


  function retrieveDocument(address _issuer, string _key) view
      public
      onlyWithGrant(_issuer, _key)
      returns (
        uint _id,
        string _name,
    	string _issuerName,
    	uint _issueTime,
    	uint _expirationTime,
    	string _offchainUrl)
  {
    address requestor = msg.sender;
    Document memory doc = documents[_issuer][_key];
    return (doc.id,
            doc.name,
	    doc.issuerName,
	    doc.issueTime,
	    doc.expirationTime,
	    doc.offchainUrl);
  }


  function requestGrant(
      address _issuer,
      string _key,
      string _requestorName)
      public
  {
    address requestor = msg.sender;
    GrantRequest memory request = GrantRequest(
      _issuer,
      _key,
      requestor,
      _requestorName,
      now,
      now + 60 * 60 * 1000,
      GrantRequestStatus.PENDING);
    grants[requestor][_issuer][_key] = request;
    GrantRequested(_issuer, _key, requestor, _requestorName);
  }


  function acceptGrant(
      address _issuer,
      string _key,
      address _requestor)
      onlyOwner()
      public
  {

    GrantRequest storage request = grants[_requestor][_issuer][_key];
    request.status = GrantRequestStatus.GRANTED;
    GrantAccepted(_issuer, _key, _requestor);
  }


  function rejectGrant(
      address _issuer,
      string _key,
      address _requestor)
      onlyOwner()
      public
  {

    GrantRequest storage request = grants[_requestor][_issuer][_key];
    request.status = GrantRequestStatus.REJECTED;
    GrantRejected(_issuer, _key, _requestor);
  }

  function addDocument(
        string _name,
    	string _key,
    	string _issuerName,
    	uint _expirationTime,
    	string _offchainUrl)
	public
  {
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