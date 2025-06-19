# app/routes.py
from flask import render_template, jsonify, request
from app import app
from web3 import Web3
import logging

# Connect to local Ethereum blockchain
w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/add_stock', methods=['POST'])
def add_stock():
    stock_name = request.form['name']
    stock_price = request.form['price']
    logging.info(f"Received request to add stock: name={stock_name}, price={stock_price}")
    try:
        # Add logic to interact with smart contract
        response = {'status': 'Stock added successfully'}
        logging.info(f"Stock added successfully: name={stock_name}, price={stock_price}")
        return jsonify(response)
    except Exception as e:
        logging.error(f"Error adding stock: {e}")
        return jsonify({'status': 'Error adding stock', 'error': str(e)}), 500

@app.route('/buy_stock', methods=['POST'])
def buy_stock():
    stock_name = request.form['name']
    logging.info(f"Received request to buy stock: name={stock_name}")
    try:
        # Add logic to interact with smart contract
        response = {'status': 'Stock purchased successfully'}
        logging.info(f"Stock purchased successfully: name={stock_name}")
        return jsonify(response)
    except Exception as e:
        logging.error(f"Error purchasing stock: {e}")
        return jsonify({'status': 'Error purchasing stock', 'error': str(e)}), 500

@app.errorhandler(404)
def error(e):
    return render_template("error_404.html")