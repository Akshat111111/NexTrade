// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PortfolioManager {
    struct Stock {
        string symbol;
        uint256 quantity;
        uint256 averagePrice;
    }

    mapping(address => Stock[]) public portfolios;

    // Function to add a stock to the portfolio
    function addStock(string memory symbol, uint256 quantity, uint256 averagePrice) public {
        portfolios[msg.sender].push(Stock(symbol, quantity, averagePrice));
    }

    // Function to get the portfolio for a user
    function getPortfolio(address user) public view returns (Stock[] memory) {
        return portfolios[user];
    }

    // Function to rebalance the portfolio (simple logic for demonstration)
    function rebalancePortfolio() public {
        Stock[] storage stocks = portfolios[msg.sender];

        // Example: Rebalance by updating average prices by some logic (customize further)
        for (uint256 i = 0; i < stocks.length; i++) {
            stocks[i].averagePrice = (stocks[i].averagePrice * 105) / 100; // Adding 5% to average price
        }
    }
}
