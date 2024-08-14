import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gamehub/MMLobby.dart';
import 'Move.dart';
import 'game.dart';
import 'confettianimation.dart';
import 'package:just_audio/just_audio.dart';
import 'GameOption.dart';
import 'GridConq.dart';
import 'HomePage.dart';
import 'MMLogic.dart';
import 'MemoryCard.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Move.dart';
import 'game.dart';
import 'confettianimation.dart';
import 'package:just_audio/just_audio.dart';
import 'GameOption.dart';
import 'GridConq.dart';
import 'HomePage.dart';
import 'MMLogic.dart';
import 'MemoryCard.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MMLogic.dart';
import 'MemoryCard.dart';
import 'confettianimation.dart';
import 'HomePage.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TicTacToeGameController with ChangeNotifier {
  final bool isMultiplayer;
  final String gameId;
  final String player1;
  final String player2;
  String? _currentPlayer;
  bool isdialogshown = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> board = List.filled(9, '');
  bool isGameOver = false;
  String Winner = "";
  String get currentPlayer {
    return _currentPlayer!;
  }

  TicTacToeGameController({
    required this.isMultiplayer,
    required this.gameId,
    required this.player1,
    required this.player2,
  }) {
    _listenToGameUpdates();
    _currentPlayer = player1;
  }

  void _listenToGameUpdates() {
    _firestore.collection('games').doc(gameId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;
        board = List<String>.from(data['board']);
        _currentPlayer = data['currentPlayer'];
        isGameOver = data['isGameOver'];
        Winner = data['Winner'];
        notifyListeners();
      }
    });
  }

  void _computerMove() {
    int bestScore = -1000;
    int bestMove = -1;
    for (int i = 0; i < 9; i++) {
      if (board[i] == "") {
        board[i] = "O";
        int score = _minimax(board, 0, false);
        board[i] = "";
        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }
    board[bestMove] = "O";
  }

  int _minimax(List<String> board, int depth, bool isMaximizing) {
    String? result = _checkWinnerForMinimax(board);
    if (result != null) {
      if (result == "X") return -10 + depth;
      if (result == "O") return 10 - depth;
      if (result == "Draw") return 0;
    }

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == "") {
          board[i] = "O";
          int score = _minimax(board, depth + 1, false);
          board[i] = "";
          bestScore = max(score, bestScore);
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == "") {
          board[i] = "X";
          int score = _minimax(board, depth + 1, true);
          board[i] = "";
          bestScore = min(score, bestScore);
        }
      }
      return bestScore;
    }
  }

  String? _checkWinnerForMinimax(List<String> board) {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var line in lines) {
      if (board[line[0]] != "" &&
          board[line[0]] == board[line[1]] &&
          board[line[0]] == board[line[2]]) {
        return board[line[0]];
      }
    }

    if (!board.contains("")) {
      return "Draw";
    }

    return null;
  }

  void makeMove(int index) {
    if (isGameOver ||
        board[index] != '' ||
        (isMultiplayer && !isPlayerTurn())) {
      return;
    }
    board[index] = (currentPlayer == player1) ? 'X' : 'O';
    notifyListeners();
    _updateFirebaseGameState();
    if (checkWinner()) {
      isGameOver = true;
      Winner = _currentPlayer!;
      notifyListeners();
      _handleGameOver();
    } else if (board.every((cell) => cell != '')) {
      isGameOver = true; // Draw
      Winner = "Draw";
      notifyListeners();
      _handleGameOver();
    } else {
      // Switch turns
      if (isMultiplayer) {
        _currentPlayer = (currentPlayer == player1) ? player2 : player1;
        notifyListeners();
        _updateFirebaseGameState();
      }
    }
    if (!isMultiplayer) {
      _computerMove();
      notifyListeners();
      _updateFirebaseGameState();
      if (checkWinner()) {
        isGameOver = true;
        Winner = player2;
        notifyListeners();
        _handleGameOver();
      } else if (board.every((cell) => cell != '')) {
        isGameOver = true; // Draw
        Winner = "Draw";
        notifyListeners();
        _handleGameOver();
      } else {
        // Switch turns
        if (isMultiplayer) {
          _currentPlayer = (currentPlayer == player1) ? player2 : player1;
          notifyListeners();
          _updateFirebaseGameState();
        }
      }
    }
  }

  bool isPlayerTurn() {
    // Check if it's the current player's turn
    return _currentPlayer == (FirebaseAuth.instance.currentUser!.email);
  }

  void _handleGameOver() async {
    // Notify Firebase or handle game over logic
    await _firestore.collection('games').doc(gameId).set({
      'isGameOver': true,
      'Winner': Winner,
    }, SetOptions(merge: true));
    isdialogshown = true;
  }

  void _updateFirebaseGameState() async {
    // Update the game state in Firebase
    await _firestore.collection('games').doc(gameId).set({
      'board': board,
      'currentPlayer': currentPlayer,
      'isGameOver': isGameOver,
      'Winner': Winner,
    });
  }

  bool checkWinner() {
    // Implement win checking logic
    List<List<int>> winningCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    for (var combo in winningCombinations) {
      if (board[combo[0]] != '' &&
          board[combo[0]] == board[combo[1]] &&
          board[combo[1]] == board[combo[2]]) {
        return true;
      }
    }
    return false;
  }

  void resetGame() {
    board = List.filled(9, '');
    isGameOver = false;
    Winner = "";
    isdialogshown = false;
    _currentPlayer = player1; // Reset to starting player
    notifyListeners();
    _updateFirebaseGameState();
  }
}
