GameHub
GameHub is a versatile gaming application developed using Flutter, Dart, and Firebase, offering a seamless and engaging experience for users. The app is designed with a clean and intuitive user interface, ensuring a smooth user journey from authentication to gameplay.

Features
1. User Authentication
Firebase Authentication: Secure login and signup functionalities are implemented using Firebase Authentication, ensuring user data privacy and security.
2. Game Options
GameHub provides users with three exciting games:

Grid Conqueror
Mode: Single Player (vs AI)
AI Implementation: The game features a sophisticated AI opponent, powered by the Minimax algorithm with Alpha-Beta pruning, allowing for a challenging gameplay experience.

Memory Match
Mode: Multiplayer
Real-time Gameplay: Engage in a memory challenge with friends, where both players' game states are synchronized in real-time using Firebase.

Tic Tac Toe
Modes:
Multiplayer: Play against another user in real-time, with game states managed through Firebase.
Single Player (vs AI): Challenge yourself against an AI opponent, utilizing the Minimax algorithm with Alpha-Beta pruning.
3. State Management
Dynamic Screen Management: All games in GameHub dynamically update their screen states using Firebase and Flutter’s state management, ensuring a responsive and real-time experience.
4. User Interface
User-Friendly UI: The application features a visually appealing and easy-to-navigate interface, enhancing user experience and engagement.

Tech Stack
Framework: Flutter
Programming Language: Dart
Backend: Firebase (Authentication, Database)

Installation
Clone the repository: git clone https://github.com/yourusername/gamehub.git
Navigate to the project directory: cd gamehub
Install dependencies: flutter pub get
Run the app: flutter run

Usage
Upon launching the app, users can sign up or log in using their credentials. Once authenticated, they can choose from three games:

Grid Conqueror: Test your skills against an advanced AI opponent.
Memory Match: Play with friends in a multiplayer memory challenge.
Tic Tac Toe: Compete in the classic game of strategy against another player.
Each game dynamically updates its state in real-time, providing a smooth and engaging user experience.

Getting Started
Prerequisites
Flutter SDK
Dart SDK
Firebase Account

Contributing
Contributions are welcome! Please fork the repository and create a pull request with your feature or bug fix.

License
This project is licensed under the MIT License - see the LICENSE file for details.
