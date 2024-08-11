import 'package:flutter/material.dart';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConfettiPainter extends CustomPainter {
  final List<Offset> particles;
  final List<Color> colors;
  final double radius;
  final List<String> shapes; // List to specify different shapes

  ConfettiPainter(this.particles, this.colors, this.radius, this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    Random random = Random();

    for (int i = 0; i < particles.length; i++) {
      paint.color = colors[i % colors.length];

      switch (shapes[i % shapes.length]) {
        case 'circle':
          canvas.drawCircle(particles[i], radius, paint);
          break;
        case 'ribbon':
          // Draw a ribbon shape
          Path path = Path();
          path.moveTo(particles[i].dx, particles[i].dy);
          path.quadraticBezierTo(
            particles[i].dx + (random.nextDouble() - 0.5) * 20,
            particles[i].dy + (random.nextDouble() - 0.5) * 20,
            particles[i].dx + (random.nextDouble() - 0.5) * 40,
            particles[i].dy + (random.nextDouble() - 0.5) * 40,
          );
          canvas.drawPath(path, paint);
          break;
        // Add more shapes as needed
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LosingAnimation extends StatefulWidget {
  @override
  _LosingAnimationState createState() => _LosingAnimationState();
}

class _LosingAnimationState extends State<LosingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated confetti or other celebratory effects
          Align(
            alignment: Alignment.bottomLeft,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    100 * (1 - _animation.value),
                  ),
                  child: Opacity(
                    opacity: _animation.value,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        FontAwesomeIcons.thumbsDown,
                        size: 50,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    100 * (1 - _animation.value),
                  ),
                  child: Opacity(
                    opacity: _animation.value,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        FontAwesomeIcons.thumbsDown,
                        size: 50,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Center text or other visual elements
          // Center(
          //   child: ScaleTransition(
          //     scale: _animation,
          //     child: const Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(
          //           'You Lost!',
          //           style: TextStyle(
          //             fontSize: 40,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.red,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class ConfettiAnimation extends StatefulWidget {
  final AnimationController controller;

  ConfettiAnimation(this.controller);

  @override
  _ConfettiAnimationState createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with TickerProviderStateMixin {
  List<Offset> particles = [];
  List<Color> colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow];
  List<String> shapes = ['circle', 'ribbon']; // Shapes list
  Random random = Random();
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
    widget.controller.addListener(() {
      if (widget.controller.status == AnimationStatus.forward) {
        generateParticles();
      }
      setState(() {});
    });
  }

  void generateParticles() {
    particles.clear();
    for (int i = 0; i < 100; i++) {
      particles.add(
        Offset(
          random.nextDouble() * MediaQuery.of(context).size.width,
          random.nextDouble() * MediaQuery.of(context).size.height,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated confetti or other celebratory effects
          Align(
            alignment: Alignment.topLeft,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    100 * (1 - _animation.value),
                  ),
                  child: Opacity(
                    opacity: _animation.value,
                    child: Image.asset(
                      'assets/images/party_poppertl.png',
                      height: 200,
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment(0.9, -1.05),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    100 * (1 - _animation.value),
                  ),
                  child: Opacity(
                    opacity: _animation.value,
                    child: Image.asset(
                      'assets/images/party_poppertr.png',
                      height: 200,
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    100 * (1 - _animation.value),
                  ),
                  child: Opacity(
                    opacity: _animation.value,
                    child: Image.asset(
                      'assets/images/party_popper.png',
                      height: 200,
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                    offset: Offset(
                      0,
                      100 * (1 - _animation.value),
                    ),
                    child: Opacity(
                      opacity: _animation.value,
                      child: Image.asset(
                        'assets/images/party_popperbr.png',
                        height: 210,
                      ),
                    ));
              },
            ),
          ),
          // Center text or other visual elements
          CustomPaint(
            size: Size.infinite,
            painter: ConfettiPainter(particles, colors, 5.0, shapes),
          ),
        ],
      ),
    );
  }
}
