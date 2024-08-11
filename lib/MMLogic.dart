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
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MemoryCard.dart';
import 'dart:async';

class MemoryMatchGame extends ChangeNotifier {
  List<MemoryCard> _cards;
  final String gameId;
  final String player1;
  final String player2;
  int _moves;
  int _score;
  int _movesThisTurn;
  MemoryCard? _firstSelectedCard;
  MemoryCard? _secondSelectedCard;
  Timer? _timer;
  int _timeElapsed;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _currentPlayer;
  bool _gameOver = false;
  MemoryMatchGame(this._cards,
      {required this.gameId, required this.player1, required this.player2})
      : _moves = 0,
        _score = 0,
        _timeElapsed = 0,
        _movesThisTurn = 0 {
    _startTimer();
    _listenToGameUpdates();
    _currentPlayer = player1;
  }

  bool _isGameWon() {
    return _cards.every((card) => card.isFaceUp);
  }

  List<MemoryCard> get cards => _cards;
  int get moves => _moves;
  int get score => _score;
  int get timeElapsed => _timeElapsed;

  String get currentPlayer {
    return _currentPlayer!;
  }

  bool get isGameOver => _isGameWon();
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_gameOver) {
        timer.cancel();
      } else {
        _timeElapsed++;
        notifyListeners();
      }
    });
  }

  void flipCard(int index) {
    if (FirebaseAuth.instance.currentUser!.email != _currentPlayer) return;

    if (_firstSelectedCard == null) {
      _firstSelectedCard = _cards[index];
      _firstSelectedCard!.isFaceUp = true;
    } else if (_secondSelectedCard == null) {
      _secondSelectedCard = _cards[index];
      _secondSelectedCard!.isFaceUp = true;
      _checkForMatch();
    }
    // _checkIfGameEnded();
    _movesThisTurn++;
    if (_movesThisTurn == 2) {
      if (_firstSelectedCard != null && _secondSelectedCard != null) {
        if (_firstSelectedCard!.imagePath != _secondSelectedCard!.imagePath) {
          Future.delayed(Duration(seconds: 1), () {
            _firstSelectedCard!.isFaceUp = false;
            _secondSelectedCard!.isFaceUp = false;
            _resetSelectedCards();
            _switchTurns();
            _updateFirestore();
            notifyListeners();
          });
        } else {
          _score++;
          _resetSelectedCards();
          _updateFirestore();
          notifyListeners();
        }
      }
      _movesThisTurn = 0;
    }
    notifyListeners();
  }

  void setover() {
    _gameOver = true;
    _timer?.cancel();
    print("here");
    FirebaseFirestore.instance.collection('games').doc(gameId).set(
        {'gameover': true, 'winner': currentPlayer}, SetOptions(merge: true));
    notifyListeners();
  }

  void _checkForMatch() {
    if (_firstSelectedCard != null && _secondSelectedCard != null) {
      if (_firstSelectedCard!.imagePath == _secondSelectedCard!.imagePath) {
        _firstSelectedCard!.isMatched = true;
        _secondSelectedCard!.isMatched = true;
      }
      if (_isGameWon()) {
        _gameOver = true;
      }
      _moves++;
      notifyListeners();
    }
  }

  void _resetSelectedCards() {
    _firstSelectedCard = null;
    _secondSelectedCard = null;
  }

  void resetGame() {
    for (var card in _cards) {
      card.isFaceUp = false;
      card.isMatched = false;
    }
    _moves = 0;
    _score = 0;
    _timeElapsed = 0;
    _firstSelectedCard = null;
    _secondSelectedCard = null;
    _cards.shuffle();
    _timer?.cancel();
    _gameOver = false;
    _startTimer();
    _currentPlayer = player1;
    _updateFirestore();
    notifyListeners();
  }

  Future<void> _updateFirestore() async {
    List<Map<String, dynamic>> cardData = _cards.map((card) {
      return {
        'id': card.id,
        'imagePath': card.imagePath,
        'isFaceUp': card.isFaceUp,
        'isMatched': card.isMatched,
      };
    }).toList();

    await _firestore.collection('games').doc(gameId).set({
      'cards': cardData,
      'moves': _moves,
      'score': _score,
      'timeElapsed': _timeElapsed,
      'currentPlayer': _currentPlayer,
      'player1': player1,
      'player2': player2,
      'gameover': false,
      'winner': "",
    });
  }

  void _listenToGameUpdates() {
    _firestore.collection('games').doc(gameId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;
        _moves = data['moves'];
        _score = data['score'];
        _timeElapsed = data['timeElapsed'];
        _currentPlayer = data['currentPlayer'];

        List<dynamic> cardData = data['cards'];
        _cards = cardData.map((card) {
          return MemoryCard(
            id: card['id'],
            imagePath: card['imagePath'],
            isFaceUp: card['isFaceUp'],
            isMatched: card['isMatched'],
          );
        }).toList();
        notifyListeners();
      }
    });
  }

  void _switchTurns() {
    if (_currentPlayer == player1) {
      _currentPlayer = player2;
    } else {
      _currentPlayer = player1;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
