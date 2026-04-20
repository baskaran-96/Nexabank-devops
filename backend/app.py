from flask import Flask, request, jsonify, session
from flask_cors import CORS
from datetime import datetime
import hashlib
import uuid
import os

app = Flask(__name__)
app.secret_key = os.environ.get('SECRET_KEY', 'nexabank-secret-key-2024')
CORS(app, supports_credentials=True, origins=["*"])

# In-memory database (replace with RDS in production)
users_db = {
    "john.doe@nexabank.com": {
        "id": "usr_001",
        "name": "John Doe",
        "email": "john.doe@nexabank.com",
        "password": hashlib.sha256("password123".encode()).hexdigest(),
        "account_number": "NX-1001-2024",
        "balance": 24530.75
    },
    "jane.smith@nexabank.com": {
        "id": "usr_002",
        "name": "Jane Smith",
        "email": "jane.smith@nexabank.com",
        "password": hashlib.sha256("password123".encode()).hexdigest(),
        "account_number": "NX-1002-2024",
        "balance": 15820.50
    }
}

transactions_db = {
    "usr_001": [
        {"id": "txn_001", "type": "credit", "amount": 5000.00, "description": "Salary Deposit", "date": "2024-12-01", "balance": 24530.75},
        {"id": "txn_002", "type": "debit", "amount": 150.00, "description": "Electric Bill", "date": "2024-11-28", "balance": 19530.75},
        {"id": "txn_003", "type": "debit", "amount": 320.00, "description": "Grocery Store", "date": "2024-11-25", "balance": 19680.75},
        {"id": "txn_004", "type": "credit", "amount": 1200.00, "description": "Freelance Payment", "date": "2024-11-20", "balance": 20000.75},
        {"id": "txn_005", "type": "debit", "amount": 89.99, "description": "Netflix & Spotify", "date": "2024-11-15", "balance": 18800.75},
    ],
    "usr_002": [
        {"id": "txn_006", "type": "credit", "amount": 3500.00, "description": "Salary Deposit", "date": "2024-12-01", "balance": 15820.50},
        {"id": "txn_007", "type": "debit", "amount": 200.00, "description": "Rent Payment", "date": "2024-11-30", "balance": 12320.50},
    ]
}

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "healthy", "service": "NexaBank API", "version": "1.0.0"})

@app.route('/api/register', methods=['POST'])
def register():
    data = request.json
    email = data.get('email', '').lower()
    name = data.get('name', '')
    password = data.get('password', '')

    if not email or not name or not password:
        return jsonify({"error": "All fields are required"}), 400

    if email in users_db:
        return jsonify({"error": "Email already registered"}), 409

    user_id = f"usr_{uuid.uuid4().hex[:6]}"
    account_number = f"NX-{uuid.uuid4().hex[:4].upper()}-2024"

    users_db[email] = {
        "id": user_id,
        "name": name,
        "email": email,
        "password": hashlib.sha256(password.encode()).hexdigest(),
        "account_number": account_number,
        "balance": 1000.00  # Welcome bonus
    }
    transactions_db[user_id] = [
        {"id": f"txn_{uuid.uuid4().hex[:6]}", "type": "credit", "amount": 1000.00,
         "description": "Welcome Bonus", "date": datetime.now().strftime("%Y-%m-%d"), "balance": 1000.00}
    ]

    return jsonify({"message": "Account created successfully", "account_number": account_number}), 201

@app.route('/api/login', methods=['POST'])
def login():
    data = request.json
    email = data.get('email', '').lower()
    password = data.get('password', '')

    user = users_db.get(email)
    if not user or user['password'] != hashlib.sha256(password.encode()).hexdigest():
        return jsonify({"error": "Invalid email or password"}), 401

    session['user_id'] = user['id']
    session['email'] = email

    return jsonify({
        "message": "Login successful",
        "user": {
            "id": user['id'],
            "name": user['name'],
            "email": user['email'],
            "account_number": user['account_number']
        }
    })

@app.route('/api/logout', methods=['POST'])
def logout():
    session.clear()
    return jsonify({"message": "Logged out successfully"})

@app.route('/api/account/<user_id>', methods=['GET'])
def get_account(user_id):
    user = next((u for u in users_db.values() if u['id'] == user_id), None)
    if not user:
        return jsonify({"error": "User not found"}), 404

    return jsonify({
        "name": user['name'],
        "email": user['email'],
        "account_number": user['account_number'],
        "balance": user['balance']
    })

@app.route('/api/transactions/<user_id>', methods=['GET'])
def get_transactions(user_id):
    txns = transactions_db.get(user_id, [])
    return jsonify({"transactions": txns, "total": len(txns)})

@app.route('/api/transfer', methods=['POST'])
def transfer():
    data = request.json
    sender_id = data.get('sender_id')
    recipient_account = data.get('recipient_account')
    amount = float(data.get('amount', 0))
    description = data.get('description', 'Fund Transfer')

    if amount <= 0:
        return jsonify({"error": "Invalid amount"}), 400

    sender = next((u for u in users_db.values() if u['id'] == sender_id), None)
    recipient = next((u for u in users_db.values() if u['account_number'] == recipient_account), None)

    if not sender:
        return jsonify({"error": "Sender not found"}), 404
    if not recipient:
        return jsonify({"error": "Recipient account not found"}), 404
    if sender['id'] == recipient['id']:
        return jsonify({"error": "Cannot transfer to same account"}), 400
    if sender['balance'] < amount:
        return jsonify({"error": "Insufficient funds"}), 400

    # Process transfer
    sender['balance'] -= amount
    recipient['balance'] += amount

    txn_date = datetime.now().strftime("%Y-%m-%d")
    txn_id = f"txn_{uuid.uuid4().hex[:6]}"

    if sender_id not in transactions_db:
        transactions_db[sender_id] = []
    transactions_db[sender_id].insert(0, {
        "id": txn_id, "type": "debit", "amount": amount,
        "description": f"Transfer to {recipient['account_number']} - {description}",
        "date": txn_date, "balance": sender['balance']
    })

    if recipient['id'] not in transactions_db:
        transactions_db[recipient['id']] = []
    transactions_db[recipient['id']].insert(0, {
        "id": f"txn_{uuid.uuid4().hex[:6]}", "type": "credit", "amount": amount,
        "description": f"Transfer from {sender['account_number']} - {description}",
        "date": txn_date, "balance": recipient['balance']
    })

    return jsonify({
        "message": "Transfer successful",
        "transaction_id": txn_id,
        "new_balance": sender['balance']
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
