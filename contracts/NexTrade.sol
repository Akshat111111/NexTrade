// contracts/NexTrade.sol
pragma solidity ^0.8.0;

contract NexTrade {
    struct Stock {
        string name;
        uint256 price;
        address owner;
    }

    mapping(string => Stock) public stocks;

     // Event for selling stock
    event StockSold(string name, address indexed seller, uint256 price);

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

     // Function to sell stock back to the contract
    function sellStock(string memory _name) public {
        Stock storage stock = stocks[_name];
        require(stock.owner == msg.sender, "You do not own this stock");
        require(stock.price > 0, "Stock does not exist");

        address payable seller = payable(stock.owner);
        uint256 sellingPrice = stock.price;

        // Reset stock ownership
        stock.owner = address(0); // Mark the stock as unsold (or you can choose to keep it in the map)
        seller.transfer(sellingPrice); // Pay the seller

        emit StockSold(_name, msg.sender, sellingPrice); // Emit event
    }

    function getStockOwner(string memory _name) public view returns (address) {
        return stocks[_name].owner;
    }
}
