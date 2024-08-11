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
import 'package:gamehub/create.dart';
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
import 'TicTacToeGame.dart';

class TicTacToeMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Tic Tac Toe",
              style: TextStyle(
                fontFamily: 'ReemKufiFun',
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8.0),
            Icon(
              Icons.videogame_asset,
              color: Colors.black,
              size: 30,
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 255, 179, 2),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(gameno: 2),
                    ),
                  );
                },
                child: Text(
                  "Play Multiplayer",
                  style: TextStyle(
                    fontFamily: 'ReemKufiFun',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 179, 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateGameScreen(gameno: 2, multi: false),
                    ),
                  );
                },
                child: Text(
                  "Play with Computer",
                  style: TextStyle(
                    fontFamily: 'ReemKufiFun',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 179, 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
