# NexTrade ERC1155 Smart Contract System

## Overview

This project involves two smart contracts: `NexTradeERC1155` and `StockERC1155`. Together, they form a decentralized stock trading platform where companies can issue stocks (using ERC1155 tokens), and users can buy and sell these stocks.

### NexTradeERC1155.sol

`NexTradeERC1155` is the main contract responsible for:

- Allowing companies to register themselves.
- Enabling companies to create stock contracts via `StockERC1155`.
- Facilitating buying and selling of company stocks through stock contracts.

### StockERC1155.sol

`StockERC1155` is a contract for managing the stocks issued by companies. It uses ERC1155 to represent the stocks issued by companies. This contract handles:

- Creating stocks with an initial supply and price.
- Allowing users to buy and sell stocks.

## Smart Contract Details

### NexTradeERC1155.sol

#### Key Features:
1. **Company Registration**:
   - Companies can register themselves and create a new stock contract.
   - Event `CompanyCreated` is emitted once a company registers.

2. **Stock Creation**:
   - After registering, a company can create stock by specifying the initial supply and price.
   - This deploys a smart contract of the company that can be handled by NexTradeERC1155 itself.

3. **Buying Stocks**:
   - Users can buy stocks from a company’s stock contract by sending the required payment (based on stock price and amount).
   - Event `StockBought` is emitted once a stock purchase is successful.

4. **Selling Stocks**:
   - Users can sell their stocks back to the company’s stock contract.
   - Event `StockSold` is emitted once a stock sale is successful.

5. **Retrieving Company Details**:
   - Functions for retrieving stock price, available stock, and stock contract for a given company.

#### Modifiers:
- `hasStockContractAndStocks`: Ensures the company has created a stock contract and has stock available for transactions.

#### Events:
- `CompanyCreated`: Emitted when a company registers itself and creates a stock contract.
- `StockCreated`: Emitted when a company creates a stock contract.
- `StockBought`: Emitted when a user buys stocks.
- `StockSold`: Emitted when a user sells stocks.

#### Error Handling:
- Custom errors are used to handle various situations such as:
  - A company attempting to create multiple stock contracts.
  - Users attempting to buy more stocks than are available.
  - Incorrect payment amounts during stock purchases.

### StockERC1155.sol

#### Key Features:
1. **Stock Creation**:
   - A company (owner) can create stock by specifying the initial supply and the price per stock.
   - The stock is represented as ERC1155 tokens, and the initial supply is minted to the company.

2. **Buying Stocks**:
   - Users can buy stocks from the company by paying the stock price. The stock is transferred to the buyer, and the available supply decreases.

3. **Selling Stocks**:
   - Users can sell stocks back to the company. The stock is transferred from the seller to the company, and the seller receives payment.

4. **View Functions**:
   - Functions to retrieve stock price, total supply, and available supply.

#### Constructor:
- Initializes the contract with a URI (for metadata) and the owner address.

## How It Works

### Company Registration and Stock Creation
1. **Registering a Company**: A company can register itself by calling `registerCompany(uri)` in `NexTradeERC1155`. This creates a new `StockERC1155` contract for the company.
   - Example: 
     ```solidity
     nexTradeContract.registerCompany("https://metadata-url.com/");
     ```

2. **Creating Stocks**: Once registered, a company can create stocks by calling `createCompanyStock(initialSupply, price)`. The company sets the initial stock supply and price per stock.
   - Example:
     ```solidity
     nexTradeContract.createCompanyStock(1000, 1 ether);
     ```

### Buying and Selling Stocks
1. **Buying Stocks**: A user can buy stocks by calling `buyCompanyStock(companyAddress, amount)` and sending the appropriate ETH value based on the stock price.
   - Example:
     ```solidity
     nexTradeContract.buyCompanyStock{value: 1 ether}(companyAddress, 10);
     ```

2. **Selling Stocks**: A user can sell their stocks back to the company by calling `sellCompanyStock(companyAddress, amount)`.
   - Example:
     ```solidity
     nexTradeContract.sellCompanyStock(companyAddress, 5);
     ```

### Stock Information Retrieval
- Users can query the price of a company’s stock by calling `getCompanyStockPrice(companyAddress)`.
- Users can also query the available supply by calling `getCompanyAvailableStocks(companyAddress)`.

## Error Handling

The contracts use custom error types for better gas efficiency and to provide meaningful error messages. Here are some common errors:

- `NexTrade__NoStockContract`: Raised when a company hasn’t created a stock contract.
- `NexTrade__NotEnoughStockAvailable`: Raised when a user tries to buy more stock than is available.
- `NexTrade__IncorrectPayment`: Raised when the ETH sent by a buyer does not match the required stock price.

## Deployment and Testing

To deploy and test the contracts using Foundry:
1. To test contracts :
```bash
forge test
```
2. Deploy contracts :
```bash
forge script script/Deploy.s.sol
```
