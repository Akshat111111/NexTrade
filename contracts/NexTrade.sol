// contracts/NexTrade.sol
pragma solidity ^0.8.0;

contract NexTrade {
    struct Stock {
        string name;
        uint256 price;
        address owner;
    }

    mapping(string => Stock) public stocks;

    function addStock(string memory _name, uint256 _price) public {
        require(stocks[_name].price == 0, "Stock already exists");
        stocks[_name] = Stock(_name, _price, msg.sender);
    }

    function buyStock(string memory _name) public payable {
        Stock storage stock = stocks[_name];
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
