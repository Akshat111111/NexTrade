from web3 import Web3

# Connect to local Ethereum node or testnet
w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))  # Or use Infura for testnets

# ABI for the PortfolioManager contract
contract_abi = [
    # Add your contract's ABI here
]

contract_address = Web3.toChecksumAddress('0xYourContractAddress')
portfolio_contract = w3.eth.contract(address=contract_address, abi=contract_abi)

def get_portfolio(user_address):
    user_address = Web3.toChecksumAddress(user_address)
    return portfolio_contract.functions.getPortfolio(user_address).call()

def add_stock(user_address, symbol, quantity, average_price):
    user_address = Web3.toChecksumAddress(user_address)
    tx = portfolio_contract.functions.addStock(symbol, quantity, average_price).buildTransaction({
        'from': user_address,
        'nonce': w3.eth.getTransactionCount(user_address)
    })
    signed_tx = w3.eth.account.signTransaction(tx, private_key="YourPrivateKey")
    w3.eth.sendRawTransaction(signed_tx.rawTransaction)

def rebalance_portfolio(user_address):
    user_address = Web3.toChecksumAddress(user_address)
    tx = portfolio_contract.functions.rebalancePortfolio().buildTransaction({
        'from': user_address,
        'nonce': w3.eth.getTransactionCount(user_address)
    })
    signed_tx = w3.eth.account.signTransaction(tx, private_key="YourPrivateKey")
    w3.eth.sendRawTransaction(signed_tx.rawTransaction)
