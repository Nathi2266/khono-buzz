# Import necessary modules from Flask and SQLAlchemy
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
import os

# Create a Flask web application instance
app = Flask(__name__)

# Configure the database
# The path to the SQLite database file will be 'instance/database.db'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database.db'
# Disable a SQLAlchemy feature to avoid an unnecessary warning
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize the SQLAlchemy object with the Flask app
db = SQLAlchemy(app)
# Initialize the Bcrypt object for password hashing
bcrypt = Bcrypt(app)

# ==================== Database Model Definition ====================
# This class defines the structure of the 'users' table in the database
class User(db.Model):
    # 'id' is the primary key, a unique identifier for each user
    id = db.Column(db.Integer, primary_key=True)
    # 'username' is a unique string, indexed for fast lookups
    username = db.Column(db.String(80), unique=True, nullable=False)
    # 'password_hash' stores the securely hashed password
    password_hash = db.Column(db.String(128), nullable=False)

    # This method provides a readable representation of the User object for debugging
    def __repr__(self):
        return f'<User {self.username}>'

# ==================== API Endpoints ====================

# Endpoint for user registration
# This route handles POST requests to '/register'
@app.route('/register', methods=['POST'])
def register():
    # Get JSON data from the request body
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    # Basic input validation
    if not username or not password:
        return jsonify({'message': 'Username and password are required'}), 400

    # Check if a user with the same username already exists
    existing_user = User.query.filter_by(username=username).first()
    if existing_user:
        return jsonify({'message': 'Username already exists'}), 409

    try:
        # Hash the password for secure storage
        hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
        # Create a new User instance
        new_user = User(username=username, password_hash=hashed_password)
        
        # Add the new user to the database session
        db.session.add(new_user)
        # Commit the session to save the user to the database
        db.session.commit()
        
        # Return a success message
        return jsonify({'message': 'User registered successfully'}), 201
    except Exception as e:
        # Rollback the transaction in case of an error
        db.session.rollback()
        return jsonify({'message': 'Registration failed', 'error': str(e)}), 500

# Endpoint for user login
# This route handles POST requests to '/login'
@app.route('/login', methods=['POST'])
def login():
    # Get JSON data from the request body
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    # Find the user by username
    user = User.query.filter_by(username=username).first()

    # Check if the user exists and the password is correct
    # bcrypt.check_password_hash() compares the plain text password to the hash
    if user and bcrypt.check_password_hash(user.password_hash, password):
        # Return a success message upon successful login
        return jsonify({'message': 'Login successful'}), 200
    else:
        # Return an error message for invalid credentials
        return jsonify({'message': 'Invalid username or password'}), 401

# ==================== Application Startup ====================

# This function will create the database tables before the first request is handled
@app.before_request
def create_tables():
    # Create the database and tables if they don't exist
    db.create_all()

# The main entry point of the application
if __name__ == '__main__':
    # Run the Flask development server
    # The 'host' parameter is set to '0.0.0.0' to make the server
    # accessible from other devices on the same network (like your Android phone)
    app.run(host='0.0.0.0', debug=True)
