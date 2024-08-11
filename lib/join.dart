import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
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
import 'TicTacToeGame.dart';

class JoinGameScreen extends StatefulWidget {
  int gameno;
  JoinGameScreen({required this.gameno});
  @override
  _JoinGameScreenState createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  final TextEditingController _gameIdController = TextEditingController();
  bool _isJoining = false;

  void _joinGame() async {
    setState(() {
      _isJoining = true;
    });

    final User? user = FirebaseAuth.instance.currentUser;
    String? player2Email = user?.email;

    if (player2Email != null) {
      DocumentReference gameRef = FirebaseFirestore.instance
          .collection('games')
          .doc(_gameIdController.text);

      gameRef.get().then((snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

          gameRef.update({
            'player2': player2Email,
            'status': 'ready',
          }).then((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => (widget.gameno == 1)
                    ? MemoryMatchScreen(
                        gameId: _gameIdController.text,
                        player1: data['player1'],
                        player2: player2Email,
                      )
                    : TicTacToeGame(
                        isMultiplayer: true,
                        gameId: _gameIdController.text,
                        player1: data['player1'],
                        player2: player2Email,
                      ),
              ),
            );
          });
        } else {
          setState(() {
            _isJoining = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Game not found!')),
          );
        }
      });
    } else {
      setState(() {
        _isJoining = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Join Game',
          style: TextStyle(
              fontFamily: 'ReemKufiFun',
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 255, 179, 2),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _gameIdController,
                decoration: InputDecoration(
                  labelText: 'Game ID',
                  labelStyle: const TextStyle(
                    fontFamily: 'ReemKufiFun',
                    color: Colors.black,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 179, 2),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 179, 2),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: const TextStyle(
                  fontFamily: 'ReemKufiFun',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              _isJoining
                  ? CircularProgressIndicator(
                      color: Color.fromARGB(255, 255, 179, 2))
                  : ElevatedButton(
                      onPressed: _joinGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 179, 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'Join Game',
                        style: TextStyle(
                            fontFamily: 'ReemKufiFun',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
