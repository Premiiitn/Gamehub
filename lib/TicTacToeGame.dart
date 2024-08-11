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
import 'TicTacToeController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_audio/just_audio.dart';

class TicTacToeGame extends StatefulWidget {
  final bool isMultiplayer;
  final String gameId;
  final String player1;
  final String player2;

  TicTacToeGame({
    required this.isMultiplayer,
    required this.gameId,
    required this.player1,
    required this.player2,
  });

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame>
    with TickerProviderStateMixin {
  late TicTacToeGameController _gameController;
  late AnimationController _animationController;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _audioPlayer = AudioPlayer();
    _initializeGame();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _initializeGame() {
    _gameController = TicTacToeGameController(
      isMultiplayer: widget.isMultiplayer,
      gameId: widget.gameId,
      player1: widget.player1,
      player2: widget.player2,
    );
  }

  void _playAnimation() {
    _animationController.forward(from: 0.0).then((_) {});
  }

  void _playSound(String Winner) async {
    bool isWinner =
        (FirebaseAuth.instance.currentUser!.email == Winner) ? true : false;
    if (isWinner) {
      await _audioPlayer.setAsset('assets/audio/win_sound.wav');
    } else {
      await _audioPlayer.setAsset('assets/audio/lose_sound.wav');
    }
    await _audioPlayer.play();
  }

  void _showGameOverDialog(String Winner) {
    bool isWinner =
        (FirebaseAuth.instance.currentUser!.email == Winner) ? true : false;
    Color color = isWinner ? Colors.blue : Colors.red;
    String mssg = isWinner ? 'You Win!' : 'You Lose!';
    if (Winner == "Draw") {
      color = Colors.grey;
      mssg = 'Match Drawn';
    }
    Text message = Text(
      mssg,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 242, 255, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
                color: color,
                width: 8.0,
                strokeAlign: BorderSide.strokeAlignOutside),
          ),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Game Over',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
              SizedBox(width: 5),
              Icon(Icons.waving_hand_rounded),
            ],
          ),
          content: message,
          actions: [
            Row(
              children: [
                SizedBox(
                  height: 40,
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: () {
                      _audioPlayer.stop();
                      _gameController.resetGame();
                      Navigator.of(context).pop();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.redo,
                          color: Colors.black,
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            'Play Again',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 7, 212, 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: SizedBox(
                    height: 40,
                    width: 120,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5.0,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: () async {
                        _audioPlayer.stop();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                        await FirebaseFirestore.instance
                            .collection('games')
                            .doc(widget.gameId)
                            .delete();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.black,
                            size: 18,
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 255, 0, 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _gameController,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Tic Tac Toe"),
        ),
        body: Consumer<TicTacToeGameController>(
          builder: (context, controller, child) {
            if (controller.isGameOver) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showGameOverDialog(controller.Winner);
                _playAnimation();
                _playSound(controller.Winner);
              });
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.isMultiplayer)
                  Text('Current Player:${controller.currentPlayer}'),
                SizedBox(height: 20),
                if (widget.isMultiplayer)
                  Text(
                    'GameID : ${controller.gameId}',
                    style: TextStyle(
                      fontFamily: 'ReemKufiFun',
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    // decoration: BoxDecoration(
                    //   // border: Border.all(
                    //   //   color: Colors.black,
                    //   //   width: 4,
                    //   // ),
                    //   borderRadius: BorderRadius.circular(12),
                    //   gradient: LinearGradient(
                    //     colors: [
                    //       Colors.grey.shade300,
                    //       Colors.grey.shade100,
                    //     ],
                    //     begin: Alignment.topLeft,
                    //     end: Alignment.bottomRight,
                    //   ),
                    // ),
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (!controller.isGameOver &&
                                controller.board[index] == '') {
                              controller.makeMove(index);
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: (index > 2) ? 8.0 : 0.0,
                                  color: Color.fromARGB(255, 255, 179, 2),
                                ),
                                left: BorderSide(
                                  width: (index % 3 != 0) ? 8.0 : 0.0,
                                  color: Color.fromARGB(255, 255, 179, 2),
                                ),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.grey.shade200,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 150),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: Tween<double>(begin: 0.0, end: 1.0)
                                        .animate(CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.elasticOut)),
                                    child: child,
                                  );
                                },
                                child: Text(
                                  controller.board[index],
                                  key: ValueKey(controller.board[index]),
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: controller.board[index] == 'X'
                                        ? Colors.red
                                        : Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
