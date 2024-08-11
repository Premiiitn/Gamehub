import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gamehub/GridConq.dart';
import 'package:gamehub/MMLobby.dart';
import 'package:gamehub/TicTacToe.dart';
import 'GameOption.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 179, 2),
        centerTitle: true,
        title: Text(
          "Game Hub",
          style: TextStyle(
            fontFamily: 'ReemKufiFun',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            GameOption(
              title: 'Memory Match',
              imagePath: 'assets/images/facedown.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(gameno: 1),
                  ),
                );
              },
            ),
            GameOption(
              title: 'Grid Conqueror',
              imagePath: 'assets/images/grid_conqueror.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(),
                  ),
                );
              },
            ),
            GameOption(
              title: 'TicTacToe',
              imagePath: 'assets/images/tictactoe.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicTacToeMain(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
