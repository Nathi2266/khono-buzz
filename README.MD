# KhonoBuzz Project

This project consists of a Flutter frontend application and a Python Flask backend API.

## Project Structure

- `backend/`: Contains the Flask backend API.
- `khonobuzz/`: Contains the Flutter frontend application.

## Backend (Flask)

The `backend` folder contains a Flask application that provides user authentication services.

### Features

- User Registration: Allows new users to register with a username and password.
- User Login: Authenticates existing users.

### Technologies Used

- Python
- Flask
- Flask-SQLAlchemy (for database interaction with SQLite)
- Flask-Bcrypt (for password hashing)

### Setup

1.  **Navigate to the backend directory:**
    ```bash
    cd backend
    ```
2.  **Create a Python virtual environment (if you haven't already):**
    ```bash
    python -m venv venv
    ```
3.  **Activate the virtual environment:**
    -   **Windows:**
        ```bash
        .\venv\Scripts\activate
        ```
    -   **macOS/Linux:**
        ```bash
        source venv/bin/activate
        ```
4.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```
5.  **Run the Flask application:**
    ```bash
    flask run --host=0.0.0.0 --port=5000
    ```
    The backend will run on `http://0.0.0.0:5000`.

### API Endpoints

-   `POST /register`: Register a new user.
    -   **Request Body (JSON):**
        ```json
        {
            "username": "your_username",
            "password": "your_password"
        }
        ```
    -   **Responses:**
        -   `201 Created`: User registered successfully.
        -   `400 Bad Request`: Username and password are required.
        -   `409 Conflict`: Username already exists.
        -   `500 Internal Server Error`: Registration failed.
-   `POST /login`: Log in an existing user.
    -   **Request Body (JSON):**
        ```json
        {
            "username": "your_username",
            "password": "your_password"
        }
        ```
    -   **Responses:**
        -   `200 OK`: Login successful.
        -   `401 Unauthorized`: Invalid username or password.

## Frontend (Flutter)

The `khonobuzz` folder contains the Flutter application, which interacts with the Flask backend.

### Features

- User Registration (UI Placeholder)
- User Login (UI Placeholder)

### Technologies Used

- Flutter
- Dart
- `http` package for API calls

### Setup

1.  **Navigate to the Flutter project directory:**
    ```bash
    cd khonobuzz
    ```
2.  **Get Flutter dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the Flutter application:**
    ```bash
    flutter run
    ```

### Important Notes for Frontend Development

-   **Backend URL:** The `AuthService` in `lib/main.dart` uses `http://10.0.2.2:5000` for Android Emulator. If you are running the backend on a physical device or a different machine, you will need to update `baseUrl` in `khonobuzz/lib/main.dart` to your machine's IP address.
-   **UI:** The current UI has placeholders for registration and login screens. You will need to implement the actual UI and integrate it with the `AuthService`.
