// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {StockERC1155} from "./StockERC1155.sol";

contract NexTradeERC1155 {
    // Struct to store company details
    struct Company {
        address owner; // onwer if company
        address stockContract; // address of stock smart contract created
    }

    mapping(address => Company) public companies; // mapping of company address / owner address to Company details

    //////////// EVENTS ////////////
    event CompanyCreated(address indexed owner, address stockContract);
    event StockCreated(address stockContract);
    event StockBought(address indexed buyer, uint256 amount);
    event StockSold(address indexed seller, uint256 amount);

    //////////// ERRORS ////////////
    error NexTrade__NoStockContract();
    error NexTrade__NoStock();
    error NexTrade__NotEnoughStockAvailable();
    error NexTrade__IncorrectPayment();
    error NexTrade__CompanyAlreadyCreatedStock();
    error NexTrade__CompanyAlreadyHasStock();

    //////////// MODIFIERS ////////////
    // modifier to check if company has created stock contract and stock
    modifier hasStockContractAndStocks(address _company) {
        require(getCompanyStockContract(_company) != address(0), NexTrade__NoStockContract());
        require(StockERC1155(getCompanyStockContract(_company)).getTotalSupply() != 0, NexTrade__NoStock());
        _;
    }

    //////////// FUNCTIONS ////////////
    // Company Registers itself using a URI
    function registerCompany(string memory uri) public {
        require(companies[msg.sender].stockContract == address(0), NexTrade__CompanyAlreadyCreatedStock());
        StockERC1155 newStockContract = new StockERC1155(uri, msg.sender);
        companies[msg.sender] = Company({owner: msg.sender, stockContract: address(newStockContract)});
        emit CompanyCreated(msg.sender, address(newStockContract));
    }

    // Create stock for a registered company
    function createCompanyStock(uint256 _initialSupply, uint256 _price) public {
        address stockContractAddress = getCompanyStockContract(msg.sender);
        require(stockContractAddress != address(0), NexTrade__NoStockContract());
        StockERC1155 stockContract = StockERC1155(stockContractAddress);
        require(stockContract.getTotalSupply() == 0, NexTrade__CompanyAlreadyHasStock());
        stockContract.createStock(_price, _initialSupply);
        emit StockCreated(stockContractAddress);
    }

    // Buy stock from a company's stock contract
    function buyCompanyStock(address _company, uint256 _amount) public payable hasStockContractAndStocks(_company) {
        address stockContractAddress = getCompanyStockContract(_company);
        StockERC1155 stockContract = StockERC1155(stockContractAddress);
        uint256 stockPrice = stockContract.getStockPrice();
        require(msg.value == stockPrice * _amount, NexTrade__IncorrectPayment());
        uint256 availableSupply = stockContract.getAvailableSupply();
        require(_amount <= availableSupply, NexTrade__NotEnoughStockAvailable());
        stockContract.buyStock{value: msg.value}(msg.sender, _amount);
        emit StockBought(msg.sender, _amount);
    }

    // Sell stock back to the company's stock contract
    function sellCompanyStock(address _company, uint256 _amount) public hasStockContractAndStocks(_company) {
        address stockContractAddress = getCompanyStockContract(_company);
        StockERC1155 stockContract = StockERC1155(stockContractAddress);

         // Check if the seller has enough stock to sell
        if (stockContract.balanceOf(msg.sender, 0) < _amount) {
            revert NexTrade__InsufficientStockToSell();
        }
        
        stockContract.sellStock(msg.sender, _amount);
        emit StockSold(msg.sender, _amount);
    }

    // Retrieve the stock contract for a company
    function getCompanyStockContract(address company) public view returns (address) {
        return companies[company].stockContract;
    }

    // Get a company's stock price
    function getCompanyStockPrice(address _company) public view hasStockContractAndStocks(_company) returns (uint256) {
        address stockContractAddress = getCompanyStockContract(_company);
        StockERC1155 stockContract = StockERC1155(stockContractAddress);
        return stockContract.getStockPrice();
    }

    // Get a company's available stocks to buy
    function getCompanyAvailableStocks(address _company) public view hasStockContractAndStocks(_company) returns (uint256) {
        address stockContractAddress = getCompanyStockContract(_company);
        StockERC1155 stockContract = StockERC1155(stockContractAddress);
        return stockContract.getAvailableSupply();
    }
}
