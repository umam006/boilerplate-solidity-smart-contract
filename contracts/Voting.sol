// SPDX-License-Identifier: GPL-3.0


//decrlare verison of solidity
pragma solidity >=0.7.0 <0.9.0;


contract Voting {
  //owner
  address private owner;

  //candidate lits
  string[] private candidateList;
  
  ///map of candidate vote count  
  mapping (string => uint256) private candidateVoteCount;
  
  ///map of recived vote  
  mapping (address => string) private votesReceived;
  
  constructor(){
      owner = msg.sender;
  }

  //function to add the candidate 
  function addCandidate(string memory candidateName) public {
      require(owner == msg.sender, "anda bukan pemilik voting");
      require(validateCandidate(candidateName) == false, "kandidat sudah terdaftar");
      candidateList.push(candidateName);
  }
  
  //function to add the candidate 
  function getCandidateList() public view returns (string[] memory){
      return candidateList;
  }
  

  //fnunction to vote the candidate using no candidate
  function vote(string memory candidateName) public {
       require(validateCandidate(candidateName), "kandidat tidak terdaftar");
       require(checkEqualString(votesReceived[msg.sender], ""), "anda telah melakukan voting");
       votesReceived[msg.sender] = candidateName;
       candidateVoteCount[candidateName] += 1;

  }

  //function returns the total votes a candidate has received
  function totalVotesFor(string memory candidateName) view public returns (uint256) {
    require(validateCandidate(candidateName), "kandidat tidak terdaftar");
    return candidateVoteCount[candidateName];
  }

  //function return candidatename and count of vote teh candidate
  function getWinnerOfVoting() view public returns (string memory, uint256) {
    string memory winnerName;
    uint count = 0;
    for(uint i = 0; i< candidateList.length; i++){
        if(candidateVoteCount[candidateList[i]] > count){
            winnerName = candidateList[i];
            count = candidateVoteCount[candidateList[i]];
        }
    }
    
    return (winnerName, count);
  }
  
  //function to candidate if candidate is exist or not return boolean
  function validateCandidate(string memory candidateName) private view returns (bool) {
      bool result = false;
      for(uint i = 0; i< candidateList.length; i++){
          if(checkEqualString(candidateList[i], candidateName)){
              result = true;
          }
      }
      return result;
  }
  
  //function to check if string is equal 
  function checkEqualString(string memory a, string memory b) private pure returns (bool){
      return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
  }
}