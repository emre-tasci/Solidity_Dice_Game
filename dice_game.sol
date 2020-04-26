
pragma solidity ^0.5.1;

/*/////YUNUS EMRE TASCI CS48001 DICE GAME HW2//////////*/


//A fair dice game

contract DiceGame{
    uint count=0;
    uint nonce=0;//to add randomness
   
    
    Player House;
    Player[]public playerInfo;
   
    
    event doesExist (address address1 ,bool isExist);

    bool exist ;
    
    struct Player{
        string pname;
        uint256 age;
        address payable Adrr;
        uint totalbalance;
        uint contractBalance;
        
    }
         //adding player to Player into array
    function addPlayer (string memory _pname, uint256 _age)public payable{
            nonce++;
            Player memory newPlayer;
            newPlayer.pname=_pname;
            newPlayer.age=_age;
            newPlayer.Adrr=msg.sender;
            newPlayer.totalbalance=msg.sender.balance;
            newPlayer.contractBalance= msg.value;
            
            playerInfo.push(newPlayer);
            
        }
    
   

//checks if the player exist in the array by looking at the address
    function CheckPlayers() public returns(bool){
        for(uint i=0; i<playerInfo.length; i++){
            if (msg.sender == playerInfo[i].Adrr)
              {
                exist=true;
                emit doesExist(playerInfo[i].Adrr,exist);
                return exist;
            }
            else {
                exist=false;
                emit doesExist(playerInfo[i].Adrr,exist);
                return exist;
            }
        }
        
        
    }
     //Setting the house
     
    constructor (DiceGame) public payable
    {
        
        //setting house as the initiliazer
        require (msg.value>=0 );
        House.Adrr=address(this);
        House.totalbalance=msg.sender.balance;
        House.contractBalance+=msg.value;
        playerInfo.push(House);
        
    }
   
    //fallback
    function() external payable {
    }
   
   //Shows the total balance on contract
    function showContractBalance()external view returns(uint){
        return address(this).balance;
    }
    
    
   //depositing money to contract with given wei amount, from the given addres.
    function deposit() public payable {
     require(exist);
      for (uint i=0; i<playerInfo.length; i++) {
        if(playerInfo[i].Adrr == msg.sender)
            {
            playerInfo[i].contractBalance+=msg.value;
            }
        }   
    }
    //withdrawing money with given value
    function withdraw(uint256 amountWei)public payable{
            nonce++;
            require(exist);
            require(0 < amountWei);
            require(address(this).balance >= amountWei);
            
                for (uint i=0; i<playerInfo.length; i++) {
    	            if(playerInfo[i].Adrr == msg.sender)
    	            {
    	            require(msg.value <= playerInfo[i].contractBalance);
    	            playerInfo[i].contractBalance -=amountWei;
                    msg.sender.transfer(amountWei);    	         
    	            }
                }
                
    }

   function PlayGame(address payable Playeraddr, uint256 betamountwei) public payable {
     require(exist);
     require(Playeraddr!=playerInfo[0].Adrr);// Check that the player is not the house.
     
     //setting max bet
     require(betamountwei<=100000000000000000 &&betamountwei!=0);// contract is not gonna be busy with 0 bets
    
    require(address(this).balance>=0.2 ether);//IF LOSS NEED TO GIVE ALL 0.2 ETHER
    // Check that the amount paid is less or equal the maximum bet
    require(msg.value <=0.1 ether);
    // Set the number bet for that player
    
    //Dice Rolling
    //since EVM is deterministic 
    //
    //we need to find randomness outside and for that block number+ block difficulty  nonce hashed together// however there will be security problem 
    //since block number can be manipulated by the miners , nonce gives it a extra randomness where it is called inside some functions 
    uint8 Rolled = uint8(uint256(keccak256(abi.encodePacked(block.number, block.difficulty,nonce,nonce**2)))%6+1);
    
    if(Rolled<4){  
        //PLAYER WINS
        for(uint i=0; i<playerInfo.length;i++){
            if (Playeraddr == playerInfo[i].Adrr)
              {
                  playerInfo[i].contractBalance += betamountwei*2;
                  //IF PLAYER WINS GETS *2 ETHER 
                 
    }
    else{
        playerInfo[i].contractBalance -= betamountwei;
        //HOUSE WINS
            
    }   
   
      }
    }
   }
    
}
