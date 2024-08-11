import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gamehub/TicTacToe.dart';
import 'package:uuid/uuid.dart';
import 'MemoryMatch.dart';
import 'GridConq.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'MemoryMatch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MemoryMatch.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MemoryMatch.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';
import 'MemoryMatch.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';
import 'MemoryMatch.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';
import 'MemoryMatch.dart';
import 'TicTacToeGame.dart';

class CreateGameScreen extends StatefulWidget {
  int gameno;
  bool multi;
  CreateGameScreen({required this.gameno, required this.multi});
  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  late String _gameId;
  late Stream<DocumentSnapshot> _gameStream;
  bool _isInitializing = true; // Flag to indicate initialization

  @override
  void initState() {
    super.initState();
    _createGame();
  }

  Future<void> _createGame() async {
    final User? user = FirebaseAuth.instance.currentUser;
    String? player1Email = user?.email;

    if (player1Email != null) {
      DocumentReference gameRef =
          await FirebaseFirestore.instance.collection('games').add({
        'status': (widget.multi == true) ? 'waiting' : 'ready',
        'player1': player1Email,
        'player2': (widget.multi == true) ? null : 'Computer',
        'game': widget.gameno == 1 ? 'MemoryMatch' : 'TicTacToe',
        'currentPlayer': player1Email,
      });

      setState(() {
        _gameId = gameRef.id;
        _gameStream = gameRef.snapshots();
        _isInitializing = false; // Mark initialization as complete
      });
    }
  }

  void _startGame() {
    DocumentReference gameRef =
        FirebaseFirestore.instance.collection('games').doc(_gameId);

    gameRef.get().then((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => (widget.gameno == 1)
                ? MemoryMatchScreen(
                    gameId: _gameId,
                    player1: FirebaseAuth.instance.currentUser!.email!,
                    player2: data['player2'],
                  )
                : TicTacToeGame(
                    isMultiplayer: widget.multi,
                    gameId: _gameId,
                    player1: FirebaseAuth.instance.currentUser!.email!,
                    player2: data['player2'],
                  ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 179, 2),
          centerTitle: true,
          title: const Text('Create Game',
              style: TextStyle(
                  fontFamily: 'ReemKufiFun', fontWeight: FontWeight.bold))),
      body: Center(
        child: _isInitializing
            ? const CircularProgressIndicator(
                color: Color.fromARGB(255, 255, 179, 2))
            : StreamBuilder<DocumentSnapshot>(
                stream: _gameStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                        color: Color.fromARGB(255, 255, 179, 2));
                  }

                  if (!snapshot.hasData) {
                    return const Text('Creating game...',
                        style: TextStyle(fontFamily: 'ReemKufiFun'));
                  }

                  var gameData = snapshot.data!.data() as Map<String, dynamic>;

                  if (gameData['status'] == 'ready') {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _startGame();
                    });
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Game ID: $_gameId',
                        style: const TextStyle(
                            fontFamily: 'ReemKufiFun',
                            fontSize: 20,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      if (gameData['status'] == 'waiting')
                        Shimmer.fromColors(
                          baseColor: Colors.black,
                          highlightColor: Color.fromARGB(255, 255, 179, 2),
                          child: const Text(
                            'Waiting for another player to join...',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ReemKufiFun',
                                color: Colors.black),
                          ),
                        ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
