# app/routes.py
from flask import render_template, jsonify, request
from app import app
from web3 import Web3

# Connect to local Ethereum blockchain
w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/add_stock', methods=['POST'])
def add_stock():
    stock_name = request.form['name']
    stock_price = request.form['price']
    if not stock_name or not stock_price:
        return jsonify({'status': 'Missing stock name or price'}), 400
    # Add logic to interact with smart contract
    return jsonify({'status': 'Stock added successfully'})

@app.route('/buy_stock', methods=['POST'])
def buy_stock():
    stock_name = request.form['name']
    if not stock_name:
        return jsonify({'status': 'Missing stock name or price'}), 400
    # Add logic to interact with smart contract
    return jsonify({'status': 'Stock purchased successfully'})
@app.errorhandler(404)
def error(e):
    return render_template("error_404.html")