import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'dart:math';
void main() {
  runApp(const JoystickExampleApp());
}

const ballSize = 20.0;
const step = 10.0;

class JoystickExampleApp extends StatelessWidget {
  const JoystickExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Joystick Example'),
        ),
        body: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const JoystickExample()),
              );
            },
            child: const Text('Joystick'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const JoystickAreaExample()),
              );
            },
            child: const Text('Joystick Area'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SquareJoystickExample()),
              );
            },
            child: const Text('Square Joystick'),
          ),
        ],
      ),
    );
  }
}

class JoystickExample extends StatefulWidget {
  const JoystickExample({Key? key}) : super(key: key);

  @override
  State<JoystickExample> createState() => _JoystickExampleState();
}

class _JoystickExampleState extends State<JoystickExample> {
  double _x = 100;
  double _y = 100;
  JoystickMode _joystickMode = JoystickMode.all;
  // Generate random target coordinates
  double _targetX = Random().nextInt(300).toDouble();
  double _targetY = Random().nextInt(300).toDouble();
  // Flag to track whether the player has won
  bool _hasWon = false;
  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }
  // Function to reset the game state
  void _resetGame() {
    setState(() {
      _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
      _y = 100;
      _targetX = Random().nextInt(300).toDouble();
      _targetY = Random().nextInt(300).toDouble();
      _hasWon = false;
    });
  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Joystick'),
        actions: [
          JoystickModeDropdown(
            mode: _joystickMode,
            onChanged: (JoystickMode value) {
              setState(() {
                _joystickMode = value;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.green,
            ),
            // Use a transparent color for the target ball
            Ball(_targetX, _targetY, color: Colors.transparent),
            Ball(_x, _y),
            Align(
              alignment: const Alignment(0, 0.8),
              child: Joystick(
                mode: _joystickMode,
                listener: (details) {
                  setState(() {
                    _x = _x + step * details.x;
                    _y = _y + step * details.y;

                    if ((_x - _targetX).abs() < 20 && (_y - _targetY).abs() < 20) {
                      _hasWon = true;
                    }
                  });
                },
              ),
            ),
            // Display the values of x and y
            Positioned(
              top: 16.0,
              left: 16.0,
              child: Text(
                'x: ${_x.toStringAsFixed(2)}, y: ${_y.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            // Display win message and restart button if the player has won
            if (_hasWon)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You Win!',
                      style: TextStyle(color: Colors.white, fontSize: 24.0),
                    ),
                    ElevatedButton(
                      onPressed: _resetGame,
                      child: Text('Restart'),
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

class JoystickAreaExample extends StatefulWidget {
  const JoystickAreaExample({Key? key}) : super(key: key);

  @override
  State<JoystickAreaExample> createState() => _JoystickAreaExampleState();
}

class _JoystickAreaExampleState extends State<JoystickAreaExample> {
  double _x = 100;
  double _y = 100;
  JoystickMode _joystickMode = JoystickMode.all;

  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Joystick Area'),
        actions: [
          JoystickModeDropdown(
            mode: _joystickMode,
            onChanged: (JoystickMode value) {
              setState(() {
                _joystickMode = value;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: JoystickArea(
          mode: _joystickMode,
          initialJoystickAlignment: const Alignment(0, 0.8),
          listener: (details) {
            setState(() {
              _x = _x + step * details.x;
              _y = _y + step * details.y;
            });
          },
          child: Stack(
            children: [
              Container(
                color: Colors.green,
              ),
              Ball(_x, _y),
            ],
          ),
        ),
      ),
    );
  }
}

class SquareJoystickExample extends StatefulWidget {
  const SquareJoystickExample({Key? key}) : super(key: key);

  @override
  State<SquareJoystickExample> createState() => _SquareJoystickExampleState();
}

class _SquareJoystickExampleState extends State<SquareJoystickExample> {
  double _x = 100;
  double _y = 100;
  JoystickMode _joystickMode = JoystickMode.all;

  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Square Joystick'),
        actions: [
          JoystickModeDropdown(
            mode: _joystickMode,
            onChanged: (JoystickMode value) {
              setState(() {
                _joystickMode = value;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.green,
            ),
            Ball(_x, _y),
            Align(
              alignment: const Alignment(0, 0.8),
              child: Joystick(
                mode: _joystickMode,
                base: JoystickSquareBase(mode: _joystickMode),
                stickOffsetCalculator: const RectangleStickOffsetCalculator(),
                listener: (details) {
                  setState(() {
                    _x = _x + step * details.x;
                    _y = _y + step * details.y;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JoystickModeDropdown extends StatelessWidget {
  final JoystickMode mode;
  final ValueChanged<JoystickMode> onChanged;

  const JoystickModeDropdown(
      {Key? key, required this.mode, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: FittedBox(
          child: DropdownButton(
            value: mode,
            onChanged: (v) {
              onChanged(v as JoystickMode);
            },
            items: const [
              DropdownMenuItem(
                  value: JoystickMode.all, child: Text('All Directions')),
              DropdownMenuItem(
                  value: JoystickMode.horizontalAndVertical,
                  child: Text('Vertical And Horizontal')),
              DropdownMenuItem(
                  value: JoystickMode.horizontal, child: Text('Horizontal')),
              DropdownMenuItem(
                  value: JoystickMode.vertical, child: Text('Vertical')),
            ],
          ),
        ),
      ),
    );
  }
}

class Ball extends StatelessWidget {
  final double x;
  final double y;
  final Color? color; // New line

  const Ball(this.x, this.y, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: ballSize,
        height: ballSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color ?? Color.fromARGB(255, 243, 4, 4), // Use provided color or default
          boxShadow: [
            BoxShadow(
              color: Colors.green,
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 3),
            )
          ],
        ),
      ),
    );
  }
}

