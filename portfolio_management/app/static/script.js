async function getPortfolio() {
    const address = document.getElementById('address').value;
    const response = await fetch(`/api/portfolio?address=${address}`);
    const portfolioData = await response.json();
    document.getElementById('portfolio-data').innerHTML = JSON.stringify(portfolioData);
}

async function addStock() {
    const address = document.getElementById('address').value;
    const symbol = document.getElementById('symbol').value;
    const quantity = document.getElementById('quantity').value;
    const averagePrice = document.getElementById('averagePrice').value;

    const response = await fetch('/api/add_stock', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            address,
            symbol,
            quantity,
            average_price: averagePrice
        })
    });

    const result = await response.json();
    alert(result.message);
}

async function rebalancePortfolio() {
    const address = document.getElementById('address').value;

    const response = await fetch('/api/rebalance', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ address })
    });

    const result = await response.json();
    alert(result.message);
}
