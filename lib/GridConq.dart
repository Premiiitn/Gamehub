import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'HomePage.dart';
import 'Move.dart';
import 'game.dart';
import 'confettianimation.dart';
import 'package:just_audio/just_audio.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late Game game;
  late AnimationController _controller;
  late bool playerWon;
  late Image partyPopper;
  late AudioPlayer _audioPlayer; // Audio player instance

  @override
  void initState() {
    super.initState();
    game = Game(gridSize: 8);

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _audioPlayer = AudioPlayer(); // Initialize AudioPlayer instance

    partyPopper = Image.asset('assets/images/party_popper.png');
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose(); // Dispose AudioPlayer
    super.dispose();
  }

  void _onCellTap(int row, int col, int movnumber) {
    if (game.isCellEmpty(row, col)) {
      setState(() {
        game.placePiece(row, col, 1); // Player move
      });
      if (game.isGameOver()) {
        playerWon = game.getWinner() == 1;
        _playAnimation();
        _playSound(playerWon); // Play sound based on game result
        return;
      }
      aiMove(movnumber);
      if (game.isGameOver()) {
        playerWon = game.getWinner() == 1;
        _playAnimation();
        _playSound(playerWon); // Play sound based on game result
        return;
      }
    }
  }

  void aiMove(int movnumber) {
    Future.delayed(Duration(milliseconds: 100), () {
      if (!game.isGameOver()) {
        Move bestMove = findBestMove(game.grid, movnumber);
        if (bestMove.row != -1 && bestMove.col != -1) {
          setState(() {
            game.placePiece(bestMove.row, bestMove.col, 2); // AI move
          });
        }
        if (game.isGameOver()) {
          playerWon = game.getWinner() == 1;
          _playAnimation();
          _playSound(playerWon); // Play sound based on game result
          return;
        }
      }
    });
  }

  void _playAnimation() {
    _controller.forward(from: 0.0).then((_) {
      playerWon = game.getWinner() == 1;
      _showGameOverDialog(game.getWinner(), playerWon);
    });
  }

  void _playSound(bool won) async {
    if (won) {
      await _audioPlayer
          .setAsset('assets/audio/win_sound.wav'); // Load win sound
    } else {
      await _audioPlayer
          .setAsset('assets/audio/lose_sound.wav'); // Load lose sound
    }
    await _audioPlayer.play(); // Play loaded sound
  }

  void _showGameOverDialog(int winner, bool playerWon) {
    Color c;
    if (playerWon) {
      c = Colors.blue;
    } else {
      c = Colors.red;
    }
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
          content: Text(winner == 1 ? 'You Win!' : 'AI Wins!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
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
                      _audioPlayer.stop(); // Stop sound
                      setState(() {
                        game = Game(gridSize: 8);
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
                        _audioPlayer.stop(); // Stop sound
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return HomePage();
                            },
                          ),
                        );
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
    int movnumber = 0;
    String whoseTurn = game.playerTurn ? "Your Turn!!" : "My Turn...";
    int playerCount = game.playerCount;
    int aiCount = game.aiCount;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grid Conqueror'),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  whoseTurn,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(game.gridSize, (row) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(game.gridSize, (col) {
                        return GestureDetector(
                          onTap: () {
                            movnumber += 1;
                            _onCellTap(row, col, movnumber);
                          },
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            margin: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: game.grid[row][col] == 0
                                  ? const Color.fromARGB(255, 242, 255, 0)
                                  : (game.grid[row][col] == 1
                                      ? Colors.blue
                                      : Colors.red),
                              border:
                                  Border.all(color: Colors.black, width: 2.0),
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Your Score : $playerCount",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Text("My Score:  $aiCount",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
              ),
            ],
          ),
          if (_controller.isAnimating)
            Stack(
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: playerWon
                        ? ConfettiAnimation(_controller)
                        : LosingAnimation(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
