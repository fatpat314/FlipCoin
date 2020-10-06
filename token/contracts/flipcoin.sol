pragma solidity ^0.5.16;


contract Betting {
    address payable public owner;
    uint256 public minimumBet;
    uint256 public totalBetsOne;
    uint256 public totalBetsTwo;
    address payable[] public players;
    uint256 public gameWinner;


    struct Player {
        uint256 amountBet;
        uint16 choice;
    }

    mapping(address => Player) public playerInfo;

    constructor() public {
        minimumBet = 100000000000000;
    }

    function checkPlayerExsists(address player) public view returns(bool){
        for(uint256 i = 0; i < players.length; i++){
            if(players[i] == player) return true;
        }
        return false;
    }

    function betHeads() payable public {
        require(!checkPlayerExsists(msg.sender));
        require(msg.value >= minimumBet);

        uint8 _choice;
        _choice = 0;

        playerInfo[msg.sender].amountBet = msg.value;
        playerInfo[msg.sender].choice = _choice;

        players.push(msg.sender);

        if(_choice == 0){
            totalBetsOne += msg.value;
        }
    }

    function betTails() payable public {
        require(!checkPlayerExsists(msg.sender));
        require(msg.value >= minimumBet);

        uint8 _choice;
        _choice = 1;

        playerInfo[msg.sender].amountBet = msg.value;
        playerInfo[msg.sender].choice = _choice;

        players.push(msg.sender);

        if(_choice == 1){
            totalBetsTwo += msg.value;
        }
    }




    function Flipcoin() public {
        address payable[1000] memory winners;
        uint256 count = 0;
        uint256 LoserBet = 0;
        uint256 WinnerBet = 0;
        address payable playerAddress;



        gameWinner = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 2;


        for(uint256 i = 0; i < players.length; i++){
            playerAddress = players[i];


         if(playerInfo[playerAddress].choice == gameWinner){
            winners[count] = playerAddress;
            count++;
         }
      }


        if ( gameWinner == 1){
             LoserBet = totalBetsTwo;
            WinnerBet = totalBetsOne;
        }
        else{
            LoserBet = totalBetsOne;
            WinnerBet = totalBetsTwo;
        }


      //Loop through winners
        for(uint256 j = 0; j < count; j++){
              // Check that the address is not empty
            if(winners[j] != address(0)){
                address add = winners[j];
                uint256 bet = playerInfo[add].amountBet;
                //Transfer the money
                winners[j].transfer((bet*(10000+(LoserBet*10000/WinnerBet)))/10000);
        }

        delete playerInfo[playerAddress];
        players.length = 0;
        LoserBet = 0;
        WinnerBet = 0;
        totalBetsOne = 0;
        totalBetsTwo = 0;
        }
    }

    function AmountOne() public view returns(uint256){
        return totalBetsOne;
    }

    function AmountTwo() public view returns(uint256){
        return totalBetsTwo;
    }

    function Winner() public view returns(string memory){
        string memory declare = "Heads";
        if (gameWinner == 0){
            declare = "Heads";
        }else{
            declare = "Tails";
        }
        return declare;
    }
}
