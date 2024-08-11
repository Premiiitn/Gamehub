
// class LosingAnimation extends StatefulWidget {
//   final AnimationController controller;

//   LosingAnimation(this.controller);

//   @override
//   _LosingAnimationState createState() => _LosingAnimationState();
// }

// class _LosingAnimationState extends State<LosingAnimation>
//     with TickerProviderStateMixin {
//   late AnimationController _confettiController;
//   late List<Particle> _particles;

//   @override
//   void initState() {
//     super.initState();
//     _confettiController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     );

//     _confettiController.addListener(() {
//       if (_confettiController.isCompleted) {
//         _confettiController.reverse();
//       }
//     });

//     _particles = List.generate(50, (index) => Particle());

//     widget.controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _confettiController.forward();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _confettiController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Stack(
//         children: [
//           Positioned.fill(
//             child: AnimatedBuilder(
//               animation: _confettiController,
//               builder: (context, child) {
//                 return Stack(
//                   children: _particles
//                       .map((particle) => Positioned(
//                             left: particle.left,
//                             top: particle.top,
//                             child: Transform.rotate(
//                               angle: particle.angle,
//                               child: Opacity(
//                                 opacity: 1.0 - _confettiController.value,
//                                 child: Container(
//                                   width: particle.size,
//                                   height: particle.size,
//                                   decoration: BoxDecoration(
//                                     color: particle.color,
//                                     shape: BoxShape.circle,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ))
//                       .toList(),
//                 );
//               },
//             ),
//           ),
//           AnimatedBuilder(
//             animation: widget.controller,
//             builder: (context, child) {
//               return Transform.scale(
//                 scale: widget.controller.value,
//                 child: Opacity(
//                   opacity: 1.0 - widget.controller.value,
//                   child: Container(
//                     padding: EdgeInsets.all(20.0),
//                     decoration: BoxDecoration(
//                       color: Colors.red.withOpacity(0.8),
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: Text(
//                       'You Lost!',
//                       style: TextStyle(
//                         fontSize: 40,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Particle {
//   final double left;
//   final double top;
//   final double size;
//   final double angle;
//   final Color color;

//   Particle()
//       : left = Random().nextDouble() * 400,
//         top = -10 - Random().nextDouble() * 400,
//         size = 5 + Random().nextDouble() * 10,
//         angle = Random().nextDouble() * 2 * pi,
//         color = Colors.primaries[Random().nextInt(Colors.primaries.length)]
//             .withOpacity(0.8);
// }

// class GameScreen extends StatefulWidget {
//   @override
//   _GameScreenState createState() => _GameScreenState();
// }

// class _GameScreenState extends State<GameScreen> {
//   late Game game;

//   @override
//   void initState() {
//     super.initState();
//     game = Game(gridSize: 8);
//   }

//   void _onCellTap(int row, int col, int movnumber) {
//     if (game.isCellEmpty(row, col)) {
//       setState(() {
//         game.placePiece(row, col, 1); // Player move
//       });
//       if (game.isGameOver()) {
//         _showGameOverDialog(game.getWinner());
//         return;
//       }
//       aiMove(movnumber);
//       if (game.isGameOver()) {
//         _showGameOverDialog(game.getWinner());
//         return;
//       }
//       // Call aiMove directly after player's move
//     }
//   }

//   void aiMove(int movnumber) {
//     Future.delayed(Duration(milliseconds: 100), () {
//       if (!game.isGameOver()) {
//         Move bestMove = findBestMove(game.grid, movnumber);
//         if (bestMove.row != -1 && bestMove.col != -1) {
//           setState(() {
//             game.placePiece(bestMove.row, bestMove.col, 2); // AI move
//           });
//         }
//         if (game.isGameOver()) {
//           _showGameOverDialog(game.getWinner());
//           return;
//         }
//         // Handle deadlock scenario (optional)
//       } else {
//         if (game.isGameOver()) {
//           _showGameOverDialog(game.getWinner());
//           return;
//         }
//       }
//     });
//   }

//   void _showGameOverDialog(int winner) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Game Over',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
//           content: Text(winner == 1 ? 'Player Wins!' : 'AI Wins!',
//               style:
//                   const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   game = Game(gridSize: 8);
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text('Play Again'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     int movnumber = 0;
//     String whoseTurn = game.playerTurn ? "Your Turn!!" : "My Turn...";
//     int playerCount = game.playerCount;
//     int aiCount = game.aiCount;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Grid Conqueror'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           const SizedBox(height: 80),
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Text(
//               whoseTurn,
//               style: const TextStyle(
//                 fontSize: 25,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(game.gridSize, (row) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(game.gridSize, (col) {
//                     return GestureDetector(
//                       onTap: () {
//                         movnumber += 1;
//                         _onCellTap(row, col, movnumber);
//                       },
//                       child: Container(
//                         width: 40.0,
//                         height: 40.0,
//                         margin: EdgeInsets.all(2.0),
//                         decoration: BoxDecoration(
//                           color: game.grid[row][col] == 0
//                               ? Color.fromARGB(255, 242, 255, 0)
//                               : (game.grid[row][col] == 1
//                                   ? Colors.blue
//                                   : Colors.red),
//                           border: Border.all(color: Colors.black, width: 2.0),
//                         ),
//                       ),
//                     );
//                   }),
//                 );
//               }),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(32.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Your Score : ${playerCount}",
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 20)),
//                 Text("My Score:  ${aiCount}",
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 20)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => _game,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Memory Match'),
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Consumer<MemoryMatchGame>(
//                 builder: (context, game, child) {
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Text('Moves: ${game.moves}',
//                           style: TextStyle(fontSize: 18)),
//                       Text('Score: ${game.score}',
//                           style: TextStyle(fontSize: 18)),
//                       Text('Time: ${game.timeElapsed}s',
//                           style: TextStyle(fontSize: 18)),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             Expanded(
//               child: Consumer<MemoryMatchGame>(
//                 builder: (context, game, child) {
//                   return GridView.builder(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 4,
//                     ),
//                     itemCount: game.cards.length,
//                     itemBuilder: (context, index) {
//                       MemoryCard card = game.cards[index];
//                       return GestureDetector(
//                         onTap: () {
//                           game.flipCard(index);
//                         },
//                         child: Container(
//                           margin: EdgeInsets.all(4.0),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.0),
//                             color: card.isFaceUp ? Colors.white : Colors.blue,
//                             image: card.isFaceUp
//                                 ? DecorationImage(
//                                     image: AssetImage(card.imagePath))
//                                 : null,
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _game.resetGame();
//               },
//               child: Text('Restart'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class MemoryMatchScreen extends StatefulWidget {
//   final String gameId;
//   final String player1;
//   final String player2;
//   MemoryMatchScreen(
//       {required this.gameId, required this.player1, required this.player2});

//   @override
//   _MemoryMatchScreenState createState() => _MemoryMatchScreenState();
// }

// class _MemoryMatchScreenState extends State<MemoryMatchScreen>
//     with TickerProviderStateMixin {
//   late MemoryMatchGame _game;
//   late Image partyPopper;
//   late AnimationController _controller;
//   int winner = 0;
//   late AudioPlayer _audioPlayer; // Audio player instance
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );
//     _audioPlayer = AudioPlayer(); // Initialize AudioPlayer instance

//     partyPopper = Image.asset('assets/images/party_popper.png');
//     _initializeGame();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _audioPlayer.dispose(); // Dispose AudioPlayer
//     super.dispose();
//   }

//   void _playAnimation() {
//     _controller.forward(from: 0.0).then((_) {
//       winner = _game.getWinner();
//       _showGameOverDialog(_game.getWinner());
//     });
//   }

//   void _playSound(bool won) async {
//     if (FirebaseAuth.instance.currentUser!.email == _game.currentPlayer) {
//       await _audioPlayer
//           .setAsset('assets/audio/win_sound.wav'); // Load win sound
//     } else {
//       await _audioPlayer
//           .setAsset('assets/audio/lose_sound.wav'); // Load lose sound
//     }
//     await _audioPlayer.play(); // Play loaded sound
//   }

//   void _showGameOverDialog(int winner) {
//     Color c;
//     if (FirebaseAuth.instance.currentUser!.email == _game.currentPlayer) {
//       c = Colors.blue;
//     } else {
//       c = Colors.red;
//     }
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: const Color.fromARGB(255, 242, 255, 0),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//             side: BorderSide(
//                 color: c,
//                 width: 8.0,
//                 strokeAlign: BorderSide.strokeAlignOutside),
//           ),
//           title: const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Game Over',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
//               SizedBox(width: 5),
//               Icon(Icons.waving_hand_rounded),
//             ],
//           ),
//           content: Text(winner == 1 ? 'Player1 Wins!' : 'Player2 Wins',
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//               )),
//           actions: [
//             Row(
//               children: [
//                 SizedBox(
//                   height: 40,
//                   width: 160,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       elevation: 5.0,
//                       backgroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15.0),
//                       ),
//                     ),
//                     onPressed: () {
//                       _audioPlayer.stop(); // Stop sound
//                       setState(() {
//                         _game.resetGame();
//                       });
//                       Navigator.of(context).pop();
//                     },
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.redo,
//                           color: Colors.black,
//                           size: 20,
//                         ),
//                         SizedBox(width: 5),
//                         Expanded(
//                           child: Text(
//                             'Play Again',
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Color.fromARGB(255, 7, 212, 14),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 5),
//                 Flexible(
//                   child: SizedBox(
//                     height: 40,
//                     width: 120,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         elevation: 5.0,
//                         backgroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15.0),
//                         ),
//                       ),
//                       onPressed: () {
//                         _audioPlayer.stop(); // Stop sound
//                         Navigator.of(context)
//                             .popUntil((route) => route.isFirst);
//                         Navigator.of(context).pushReplacement(
//                           MaterialPageRoute(
//                             builder: (context) {
//                               return HomePage();
//                             },
//                           ),
//                         );
//                       },
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.exit_to_app,
//                             color: Colors.black,
//                             size: 18,
//                           ),
//                           SizedBox(width: 5),
//                           Expanded(
//                             child: Text(
//                               'Back',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Color.fromARGB(255, 255, 0, 0),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _initializeGame() {
//     List<String> imagePaths = [
//       'assets/images/card_1.jpg',
//       'assets/images/card_2.jpg',
//       'assets/images/card_3.jpg',
//       'assets/images/card_4.jpg',
//       'assets/images/card_5.jpg',
//       'assets/images/card_6.jpg',
//       'assets/images/card_7.jpg',
//       'assets/images/card_8.jpg',
//     ];

//     List<MemoryCard> cards = [];
//     for (int i = 0; i < imagePaths.length; i++) {
//       cards.add(MemoryCard(id: i * 2, imagePath: imagePaths[i]));
//       cards.add(MemoryCard(id: i * 2 + 1, imagePath: imagePaths[i]));
//     }

//     cards.shuffle();
//     _game = MemoryMatchGame(
//       cards,
//       gameId: widget.gameId,
//       player1: widget.player1,
//       player2: widget.player2,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider.value(
//       value: _game,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Memory Match'),
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Consumer<MemoryMatchGame>(
//                 builder: (context, game, child) {
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Text('Moves: ${game.moves}',
//                           style: TextStyle(fontSize: 18)),
//                       Text('Score: ${game.score}',
//                           style: TextStyle(fontSize: 18)),
//                       Text('Time: ${game.timeElapsed}s',
//                           style: TextStyle(fontSize: 18)),
//                       Text('Current Player: ${game.currentPlayer}',
//                           style:
//                               TextStyle(fontSize: 18)), // Show current player
//                     ],
//                   );
//                 },
//               ),
//             ),
//             Expanded(
//               child: Consumer<MemoryMatchGame>(
//                 builder: (context, game, child) {
//                   return GridView.builder(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 4,
//                     ),
//                     itemCount: game.cards.length,
//                     itemBuilder: (context, index) {
//                       MemoryCard card = game.cards[index];
//                       return GestureDetector(
//                         onTap: () {
//                           winner = game.getWinner();
//                           if (winner == 0)
//                             game.flipCard(index);
//                           else {
//                             _playAnimation();
//                           }
//                         },
//                         child: Container(
//                           margin: EdgeInsets.all(4.0),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.0),
//                             color: card.isFaceUp ? Colors.white : Colors.blue,
//                             image: card.isFaceUp
//                                 ? DecorationImage(
//                                     image: AssetImage(card.imagePath))
//                                 : null,
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//             Text("Game Id: ${widget.gameId}"),
//             if (_controller.isAnimating)
//               Stack(
//                 children: [
//                   Center(
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       height: MediaQuery.of(context).size.height,
//                       child: FirebaseAuth.instance.currentUser!.email ==
//                               _game.currentPlayer
//                           ? ConfettiAnimation(_controller)
//                           : LosingAnimation(),
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider.value(
//       value: _game,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Memory Match'),
//         ),
//         body: Stack(
//           children: [
//             Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Consumer<MemoryMatchGame>(
//                     builder: (context, game, child) {
//                       return Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Text('Moves: ${game.moves}',
//                               style: TextStyle(fontSize: 18)),
//                           Text('Score: ${game.score}',
//                               style: TextStyle(fontSize: 18)),
//                           Text('Time: ${game.timeElapsed}s',
//                               style: TextStyle(fontSize: 18)),
//                           Text('Current Player: ${game.currentPlayer}',
//                               style: TextStyle(fontSize: 18)),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: Consumer<MemoryMatchGame>(
//                     builder: (context, game, child) {
//                       return GridView.builder(
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 4,
//                         ),
//                         itemCount: game.cards.length,
//                         itemBuilder: (context, index) {
//                           MemoryCard card = game.cards[index];
//                           return GestureDetector(
//                             onTap: () async {
//                               gameover=FirebaseFirestore.instance.collection('games').doc(_game.gameId).get()
//                               if (!game.isGameOver && !gameover) {
//                                 game.flipCard(index);
//                               } else {
//                                 if(!gameover){
//                                 await FirebaseFirestore.instance.collection('games').doc(_game.gameId).set({'gameover':true});
//                                 await FirebaseFirestore.instance.collection('games').doc(_game.gameId).set({'winner':_game.currentPlayer});
//                                 }
//                                 _game.setover();
//                                 _playAnimation();
//                                 _showGameOverDialog();
//                               }
//                             },
//                             child: Container(
//                               margin: EdgeInsets.all(4.0),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 color:
//                                     card.isFaceUp ? Colors.white : Colors.blue,
//                                 image: card.isFaceUp
//                                     ? DecorationImage(
//                                         image: AssetImage(card.imagePath))
//                                     : null,
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 Text("Game Id: ${widget.gameId}"),
//               ],
//             ),
//             if (_controller.isAnimating)
//               Stack(
//                 children: [
//                   Center(
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       height: MediaQuery.of(context).size.height,
//                       child:
//                           (winner == FirebaseAuth.instance.currentUser!.email)
//                               ? ConfettiAnimation(_controller)
//                               : LosingAnimation(),
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider.value(
//       value: _game,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Memory Match'),
//         ),
//         body: StreamBuilder<DocumentSnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('games')
//               .doc(widget.gameId)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }

//             if (snapshot.hasError) {
//               return Center(child: Text('Something went wrong'));
//             }

//             if (!snapshot.hasData || !snapshot.data!.exists) {
//               return Center(child: Text('Game not found'));
//             }

//             var gameData = snapshot.data!.data() as Map<String, dynamic>;
//             bool gameover = gameData['gameover'] ?? false;
//             String winner = gameData['winner'] ?? '';

//             if (gameover) {
//               Future.delayed(Duration.zero, () {
//                 if (!_game.isDialogShown) {
//                   if (winner == FirebaseAuth.instance.currentUser!.email) {
//                     _showGameOverDialog(true);
//                     _game.setDialogShown(true);
//                   } else {
//                     _showGameOverDialog(false);
//                     _game.setDialogShown(true);
//                   }
//                 }
//               });
//             }

//             return Stack(
//               children: [
//                 Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Consumer<MemoryMatchGame>(
//                         builder: (context, game, child) {
//                           return Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Text('Moves: ${game.moves}',
//                                   style: TextStyle(fontSize: 18)),
//                               Text('Score: ${game.score}',
//                                   style: TextStyle(fontSize: 18)),
//                               Text('Time: ${game.timeElapsed}s',
//                                   style: TextStyle(fontSize: 18)),
//                               Text('Current Player: ${game.currentPlayer}',
//                                   style: TextStyle(fontSize: 18)),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                     Expanded(
//                       child: Consumer<MemoryMatchGame>(
//                         builder: (context, game, child) {
//                           return GridView.builder(
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 4,
//                             ),
//                             itemCount: game.cards.length,
//                             itemBuilder: (context, index) {
//                               MemoryCard card = game.cards[index];
//                               return GestureDetector(
//                                 onTap: () {
//                                   if (!game.isGameOver) {
//                                     game.flipCard(index);
//                                   } else {
//                                     setState(() {
//                                       _game.setover();
//                                       _playAnimation();
//                                       if (!_game.isDialogShown) {
//                                         if (winner ==
//                                             FirebaseAuth
//                                                 .instance.currentUser!.email) {
//                                           _showGameOverDialog(true);
//                                           _game.setDialogShown(true);
//                                         } else {
//                                           _showGameOverDialog(false);
//                                           _game.setDialogShown(true);
//                                         }
//                                       }
//                                     });
//                                   }
//                                 },
//                                 child: Container(
//                                   margin: EdgeInsets.all(4.0),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                     color: card.isFaceUp
//                                         ? Colors.white
//                                         : Colors.blue,
//                                     image: card.isFaceUp
//                                         ? DecorationImage(
//                                             image: AssetImage(card.imagePath))
//                                         : null,
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                     Text("Game Id: ${widget.gameId}"),
//                   ],
//                 ),
//                 if (_controller.isAnimating)
//                   Stack(
//                     children: [
//                       Center(
//                         child: SizedBox(
//                           width: MediaQuery.of(context).size.width,
//                           height: MediaQuery.of(context).size.height,
//                           child:
//                               FirebaseAuth.instance.currentUser!.email == winner
//                                   ? ConfettiAnimation(_controller)
//                                   : null,
//                         ),
//                       ),
//                     ],
//                   ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider.value(
//       value: _game,
//       child: Scaffold(
//         backgroundColor: const Color.fromARGB(255, 255, 17, 0),
//         appBar: AppBar(
//           backgroundColor: const Color.fromARGB(255, 255, 17, 0),
//           centerTitle: true,
//           title: Text(
//             'Memory Match',
//             style: TextStyle(
//               fontSize: 24,
//               color: Colors.yellowAccent,
//               fontFamily: 'ReemKufiFun',
//               fontWeight: FontWeight.bold,
//               shadows: [
//                 Shadow(
//                   blurRadius: 5.0,
//                   color: Colors.black.withOpacity(0.8),
//                   offset: Offset(2.0, 2.0),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         body: StreamBuilder<DocumentSnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('games')
//               .doc(widget.gameId)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }

//             if (snapshot.hasError) {
//               return Center(child: Text('Something went wrong'));
//             }

//             if (!snapshot.hasData || !snapshot.data!.exists) {
//               return Center(child: Text('Game not found'));
//             }

//             var gameData = snapshot.data!.data() as Map<String, dynamic>;
//             bool gameover = gameData['gameover'] ?? false;
//             String winner = gameData['winner'] ?? '';
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               if (gameover) {
//                 bool isWinner =
//                     winner == FirebaseAuth.instance.currentUser!.email;
//                 _showGameOverDialog(isWinner);
//                 _playSound(isWinner);
//                 _playAnimation();
//               }
//             });

//             return Stack(
//               children: [
//                 Column(
//                   children: [
//                     SizedBox(height: 20),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Consumer<MemoryMatchGame>(
//                         builder: (context, game, child) {
//                           return Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Text(
//                                 'Time Elapsed: ${game.timeElapsed}s',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.yellowAccent,
//                                   fontFamily: 'ReemKufiFun',
//                                   shadows: [
//                                     Shadow(
//                                       blurRadius: 5.0,
//                                       color: Colors.black.withOpacity(0.8),
//                                       offset: Offset(2.0, 2.0),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Consumer<MemoryMatchGame>(
//                         builder: (context, game, child) {
//                           return Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Text(
//                                 'Current Player: ${_game.currentPlayer}',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.yellowAccent,
//                                   fontFamily: 'ReemKufiFun',
//                                   shadows: [
//                                     Shadow(
//                                       blurRadius: 5.0,
//                                       color: Colors.black.withOpacity(0.8),
//                                       offset: Offset(2.0, 2.0),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 40),
//                     Consumer<MemoryMatchGame>(
//                       builder: (context, game, child) {
//                         return Expanded(
//                           child: GridView.builder(
//                             gridDelegate:
//                                 const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 4,
//                             ),
//                             itemCount: game.cards.length,
//                             itemBuilder: (context, index) {
//                               MemoryCard card = game.cards[index];
//                               return GestureDetector(
//                                   onTap: () {
//                                     if (!game.isGameOver) {
//                                       game.flipCard(index);
//                                     } else {
//                                       setState(() {
//                                         _game.setover();
//                                       });
//                                     }
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         color: Colors.black,
//                                         borderRadius:
//                                             BorderRadius.circular(10.0),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color:
//                                                 Colors.black.withOpacity(0.5),
//                                             spreadRadius: 2,
//                                             blurRadius: 5,
//                                             offset: Offset(0,
//                                                 3), // changes position of shadow
//                                           ),
//                                         ]),
//                                     margin: EdgeInsets.all(4.0),
//                                     child: Container(
//                                       padding: EdgeInsets.all(2.0),
//                                       decoration: BoxDecoration(
//                                         color: Colors
//                                             .black, // This will act as the border
//                                         borderRadius: BorderRadius.circular(
//                                             12.0), // Slightly larger radius to simulate outside stroke
//                                       ),
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(10.0),
//                                           color: card.isFaceUp
//                                               ? Colors.white
//                                               : Colors.blue,
//                                           image: card.isFaceUp
//                                               ? DecorationImage(
//                                                   image: AssetImage(
//                                                       card.imagePath),
//                                                 )
//                                               : DecorationImage(
//                                                   image: AssetImage(
//                                                       'assets/images/facedown.jpg'),
//                                                 ),
//                                         ),
//                                       ),
//                                     ),
//                                   ));
//                             },
//                           ),
//                         );
//                       },
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         "Game Id: ${widget.gameId}",
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.yellowAccent,
//                           fontFamily: 'ReemKufiFun',
//                           shadows: [
//                             Shadow(
//                               blurRadius: 5.0,
//                               color: Colors.black.withOpacity(0.8),
//                               offset: Offset(2.0, 2.0),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (_controller.isAnimating)
//                   Center(
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       height: MediaQuery.of(context).size.height,
//                       child: FirebaseAuth.instance.currentUser!.email == winner
//                           ? ConfettiAnimation(_controller)
//                           : LosingAnimation(),
//                     ),
//                   ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }