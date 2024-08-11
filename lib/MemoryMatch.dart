import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
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

class MemoryMatchScreen extends StatefulWidget {
  final String gameId;
  final String player1;
  final String player2;
  MemoryMatchScreen(
      {required this.gameId, required this.player1, required this.player2});

  @override
  _MemoryMatchScreenState createState() => _MemoryMatchScreenState();
}

class _MemoryMatchScreenState extends State<MemoryMatchScreen>
    with TickerProviderStateMixin {
  late MemoryMatchGame _game;
  late AnimationController _controller;
  late AudioPlayer _audioPlayer;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _audioPlayer = AudioPlayer();

    _initializeGame();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAnimation() {
    _controller.forward(from: 0.0).then((_) {});
  }

  void _playSound(bool isWinner) async {
    if (isWinner) {
      await _audioPlayer.setAsset('assets/audio/win_sound.wav');
    } else {
      await _audioPlayer.setAsset('assets/audio/lose_sound.wav');
    }
    await _audioPlayer.play();
  }

  void _showGameOverDialog(bool isWinner) {
    Color c = isWinner ? Colors.blue : Colors.red;
    Text mssg = Text(
      isWinner ? 'You Win!' : 'You Lose!',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: c,
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
                color: c,
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
          content: mssg,
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
                      setState(() {
                        _game.resetGame();
                      });
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
                            builder: (context) {
                              return HomePage();
                            },
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

  void _initializeGame() {
    List<String> imagePaths = [
      'assets/images/card_1.jpg',
      'assets/images/card_2.jpg',
      'assets/images/card_3.jpg',
      'assets/images/card_4.jpg',
      'assets/images/card_5.jpg',
      'assets/images/card_6.jpg',
      'assets/images/card_7.jpg',
      'assets/images/card_8.jpg',
    ];

    List<MemoryCard> cards = [];
    for (int i = 0; i < imagePaths.length; i++) {
      cards.add(MemoryCard(id: i * 2, imagePath: imagePaths[i]));
      cards.add(MemoryCard(id: i * 2 + 1, imagePath: imagePaths[i]));
    }

    cards.shuffle();
    _game = MemoryMatchGame(
      cards,
      gameId: widget.gameId,
      player1: widget.player1,
      player2: widget.player2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _game,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.jpg', // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    title: Text(
                      'Memory Match',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.yellowAccent,
                        fontFamily: 'ReemKufiFun',
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black.withOpacity(0.8),
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('games')
                          .doc(widget.gameId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Something went wrong'));
                        }

                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return Center(child: Text('Game not found'));
                        }

                        var gameData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        bool gameover = gameData['gameover'] ?? false;
                        String winner = gameData['winner'] ?? '';
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (gameover) {
                            bool isWinner = winner ==
                                FirebaseAuth.instance.currentUser!.email;
                            _showGameOverDialog(isWinner);
                            _playSound(isWinner);
                            _playAnimation();
                          }
                        });

                        return Column(
                          children: [
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Consumer<MemoryMatchGame>(
                                builder: (context, game, child) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Time Elapsed: ${game.timeElapsed}s',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.yellowAccent,
                                          fontFamily: 'ReemKufiFun',
                                          shadows: [
                                            Shadow(
                                              blurRadius: 5.0,
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              offset: Offset(2.0, 2.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Consumer<MemoryMatchGame>(
                                builder: (context, game, child) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            'Current Player: ${_game.currentPlayer}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.yellowAccent,
                                              fontFamily: 'ReemKufiFun',
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 5.0,
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                  offset: Offset(2.0, 2.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                            Consumer<MemoryMatchGame>(
                              builder: (context, game, child) {
                                return Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                    ),
                                    itemCount: game.cards.length,
                                    itemBuilder: (context, index) {
                                      MemoryCard card = game.cards[index];
                                      return GestureDetector(
                                        onTap: () {
                                          if (!game.isGameOver) {
                                            game.flipCard(index);
                                          } else {
                                            setState(() {
                                              _game.setover();
                                            });
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          margin: EdgeInsets.all(4.0),
                                          child: Container(
                                            padding: EdgeInsets.all(2.0),
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                color: card.isFaceUp
                                                    ? Colors.white
                                                    : Colors.red,
                                                image: card.isFaceUp
                                                    ? DecorationImage(
                                                        image: AssetImage(
                                                            card.imagePath),
                                                      )
                                                    : DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/facedown.jpg'),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Game Id: ${widget.gameId}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.yellowAccent,
                                  fontFamily: 'ReemKufiFun',
                                  shadows: [
                                    Shadow(
                                      blurRadius: 5.0,
                                      color: Colors.black.withOpacity(0.8),
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
