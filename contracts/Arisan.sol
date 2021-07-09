// SPDX-License-Identifier: GPL-3.0

//decrlare verison of solidity
pragma solidity >=0.7.0 <0.9.0;

contract Arisan {
    //woner of arisan
    address host;

    //list member of arisan
    address[] members;

    //list winner of arisan
    address[] winners;

    //list member have paid arisan
    address[] pools;


    //set the owner on deploy the contract
    constructor(){
        host = msg.sender;
    }

   
    function checkExist(address[] memory memberArray,  address member) private pure returns (bool){
        bool result;
        for(uint i = 0; i < memberArray.length; i++){
            if(memberArray[i] == member){
                result = true;
            }
        }
        return result;
    }

    ///function for join to arisan
    function join() public {
        require(checkExist(members, msg.sender) == false, "anda sudah menjadi member arisan!");
        members.push(msg.sender);
    }

    ///function for pay arisan
    function pay() public payable {
        require(msg.value == 0.01 ether, "pembayaran harus 0.01 ether");
        require(checkExist(members, msg.sender) == true, "anda belum menjadi member arisan!");
        require(checkExist(pools, msg.sender) == false, "Anda sudah membayar arisan");
        pools.push(msg.sender);
    }

   ///function return all arisan member 
    function getMembers() public view returns (address[] memory){
        return members;
    }

    ///function return all arisan winner arisan
    function getTheWinners() public view returns (address[] memory){
        return winners;
    }

    //function get list member have paid arisan
    function getPollBalance() public view returns (uint){
        return address(this).balance;
    }

    // function to get random number
    function random() private view returns (uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, members)));
    }
 
    // function to suffle the arisan winner
    function randomWinner() private view returns (address){
        address randMember = members[random() % members.length];
        if(checkExist(winners, randMember)){
            return randomWinner();
        } else {
            return randMember;
        }
    }

    // function to get the arisan winner
    function pickWinner() public  {
        require(msg.sender == host, "anda bukan pemilik arisan!");
        address winner = randomWinner();
        winners.push(winner);
        pools = new address[](0);
        payable(winner).transfer(address(this).balance);
    }

     // function to get the last arisan winner
    function getLastWinner() public view returns (address){
        return winners[winners.length - 1];
    }

     // function to reset  arisan
    function resetArisan() public {
        require(msg.sender == host, "anda bukan pemilik arisan!");
        winners = new address[](0);
    }
    
}
