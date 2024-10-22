from flask import Flask, jsonify, render_template, request
from web3_interface import get_portfolio, add_stock, rebalance_portfolio
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Route to render the homepage
@app.route('/')
def index():
    return render_template('index.html')

# API endpoint to get a portfolio
@app.route('/api/portfolio', methods=['GET'])
def portfolio():
    user_address = request.args.get('address')
    portfolio_data = get_portfolio(user_address)
    return jsonify(portfolio_data)

# API endpoint to add a stock
@app.route('/api/add_stock', methods=['POST'])
def add_stock_route():
    data = request.json
    add_stock(data['address'], data['symbol'], data['quantity'], data['average_price'])
    return jsonify({"message": "Stock added successfully"})

# API endpoint to rebalance the portfolio
@app.route('/api/rebalance', methods=['POST'])
def rebalance():
    user_address = request.json.get('address')
    rebalance_portfolio(user_address)
    return jsonify({"message": "Portfolio rebalanced successfully"})

if __name__ == '__main__':
    app.run(debug=True)
