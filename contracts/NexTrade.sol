// contracts/NexTrade.sol
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/AccessControl.sol";

contract NexTrade is AccessControl {
    bytes32 public constant BROKER_ROLE = keccak256("BROKER_ROLE");
    bytes32 public constant TRADER_ROLE = keccak256("TRADER_ROLE");

    struct Stock {
        string name;
        uint256 price;
        address owner;
    }

    mapping(string => Stock) public stocks;

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(BROKER_ROLE, msg.sender); // Assigning Broker Role to the contract deployer initially
    }

    function addStock(string memory _name, uint256 _price) public {
        require(stocks[_name].price == 0, "Stock already exists");
        require(hasRole(BROKER_ROLE, msg.sender), "Only brokers can add stocks");
        stocks[_name] = Stock(_name, _price, msg.sender);
    }

    function buyStock(string memory _name) public payable {
        Stock storage stock = stocks[_name];
        require(hasRole(TRADER_ROLE, msg.sender), "Only traders can buy stocks");
        require(stocks[name].price > 0, "Stock does not exist");
        require(msg.value >= stocks[name].price, "Not enough Ether sent");
        require(msg.value == stock.price, "Incorrect amount");
        require(stock.owner != address(0), "Stock does not exist");

        address payable seller = payable(stock.owner);
        stock.owner = msg.sender;
        seller.transfer(msg.value);
    }

    function getStockOwner(string memory _name) public view returns (address) {
        return stocks[_name].owner;
    }
}


