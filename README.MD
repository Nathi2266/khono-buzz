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

1.  **Meet Prerequisites:** Ensure you have completed all the steps in the [Prerequisites](#prerequisites) section.
2.  **Navigate to the Flutter project directory:**
    ```bash
    cd khonobuzz
    ```
3.  **Get Flutter dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Run the Flutter application:**
    ```bash
    flutter run
    ```

### Important Notes for Frontend Development

-   **Backend URL:** The `AuthService` in `lib/main.dart` uses `http://10.0.2.2:5000` for Android Emulator. If you are running the backend on a physical device or a different machine, you will need to update `baseUrl` in `khonobuzz/lib/main.dart` to your machine's IP address.
-   **UI:** The current UI has placeholders for registration and login screens. You will need to implement the actual UI and integrate it with the `AuthService`.

## Prerequisites

Before setting up the frontend and backend, ensure you have the following installed and configured:

### 1. Flutter SDK

Download and install the Flutter SDK from the official Flutter website. Follow the installation guide for your operating system: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)

### 2. Android SDK (via Android Studio)

For Android development, you will need the Android SDK, which is typically installed with Android Studio.

*   Download and install Android Studio from [https://developer.android.com/studio](https://developer.android.com/studio).
*   During the Android Studio setup, ensure that the Android SDK, Android SDK Command-line Tools, and Android SDK Build-Tools are installed.

### 3. Java Development Kit (JDK)

Flutter's Android development tools require a Java Development Kit.

*   **Check Java Version:** Open your terminal or command prompt and run:
    ```bash
    java -version
    ```
    If Java is not found or the version is old, you will need to install it.
*   **Installation:** Download and install a recent OpenJDK version (e.g., from Adoptium: [https://adoptium.net/](https://adoptium.net/)). Follow the installation instructions for your operating system.

### 4. Environment Variables

Properly configure the following environment variables:

*   **`FLUTTER_HOME`**: Set this to the path where you extracted the Flutter SDK.
*   **`ANDROID_HOME`**: Set this to the path of your Android SDK installation (e.g., `C:\Users\YOUR_USERNAME\AppData\Local\Android\sdk`).
*   **`JAVA_HOME`**: Set this to the path of your Java JDK installation (e.g., `C:\Program Files\Java\jdk-XX.X.X`).
*   **`PATH`**: Add the following to your system's PATH variable:
    *   `%FLUTTER_HOME%\bin`
    *   `%ANDROID_HOME%\cmdline-tools\latest\bin` (or similar path depending on your SDK setup)
    *   `%ANDROID_HOME%\platform-tools`
    *   `%JAVA_HOME%\bin`

After setting environment variables, restart your terminal or IDE to ensure they are loaded correctly.

### 5. Verify Setup

Run the following command in your terminal to verify your Flutter and Android setup:
```bash
flutter doctor
```
This command will check your environment and display a report of the status of your Flutter installation.

## Screenshots

Here are some screenshots of the KhonoBuzz application:

### Landing Screen

![Landing Screen](khonobuzz/assets/images/Screenshot%202025-08-27%20125821.png)

### Login Screen

![Login Screen](khonobuzz/assets/images/Screenshot%202025-08-27%20125838.png)

### Registration Screen

![Registration Screen](khonobuzz/assets/images/Screenshot%202025-08-27%20125913.png)

### Dashboard Screen

![Dashboard Screen](khonobuzz/assets/images/Screenshot%202025-08-28%20041205.png)

### App Drawer (Navigation Menu)

![App Drawer](khonobuzz/assets/images/Screenshot%202025-08-27%20084803.png)