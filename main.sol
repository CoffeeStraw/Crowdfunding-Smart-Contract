pragma solidity >=0.4.22 <0.6.0;

// Inizializzazione per il test:
// "Prova Esame", 5, 60

contract FundRaising {
    address payable owner;
    
    string public description;
    uint public goal;
    uint public end_time;
    uint public total = 0;
    
    // Tabella in cui ogni donatore viene registrato con la propria transazione
    mapping(address=>uint) donations;
    
    // Una raccolta fondi è caratterizzata da una descrizione, un obbiettivo monetario ed un limite di tempo
    constructor(string memory _description, uint _goal, uint _timeLimit) public {
        owner = msg.sender;
        description = _description;
        goal = _goal;
        end_time = now + _timeLimit;
    }
    
    // Finanziamento della raccolta fondi
    function pay() payable public {
        require(now < end_time, "La raccolta fondi è terminata.");
        require(total < goal, "È già stato raggiunto l'obbiettivo.");
        require(msg.value > 0, "Devi mandare degli ether");
        donations[msg.sender] += msg.value;
        total += msg.value;
    }
    
    // Ritiro dei soldi da parte dell'owner
    function withdrawOwner() public {
        require(msg.sender == owner, "Devi essere il proprietario.");
        require(total >= goal, "La Raccolta fondi non si è ancora conclusa.");
        owner.transfer(address(this).balance);
    }
    
    // Ritiro dei soldi da parte del singolo finanziatore
    function withdraw() public {
        require(now > end_time, "La raccolta fondi non si è ancora conclusa.");
        require(total < goal, "Non puoi riottenere i soldi indietro dal momento che la raccolta fondi è andata a buon fine.");
        require(donations[msg.sender] != 0, "Hai già riottenuto indietro la tua somma.");
        uint amount = donations[msg.sender];
        total -= amount;
        donations[msg.sender] = 0;
        // Invio solo dopo aver decrementato dal totale
        address(msg.sender).transfer(amount);
    }
}