import 'package:flutter/material.dart';

void main() {
  runApp(TapBattleGame());
}

class TapBattleGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tap Battle Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TapBattleScreen(),
    );
  }
}

class TapBattleScreen extends StatefulWidget {
  @override
  _TapBattleScreenState createState() => _TapBattleScreenState();
}

class _TapBattleScreenState extends State<TapBattleScreen> {
  double redHeight = 0.5; // Initial height as a percentage of the screen
  double blueHeight = 0.5; // Initial height as a percentage of the screen
  bool gameEnded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showGameInstructions();
    });
  }

  void _showGameInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Instructions'),
        content: Text(
            'Tap on your side of the screen to win. The first player to cover the entire screen wins the game!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Start'),
          ),
        ],
      ),
    );
  }

  void _showWinnerDialog(String winner) {
    if (!gameEnded) {
      setState(() {
        gameEnded = true;
      });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('Game Over'),
          content: Text('$winner Wins!'),
          actions: [
            ElevatedButton(
              onPressed: _resetGame,
              child: Text('Restart'),
            ),
          ],
        ),
      );
    }
  }

  void _increaseRed() {
    if (!gameEnded && redHeight < 1.0 && blueHeight > 0.0) {
      setState(() {
        redHeight += 0.05;
        blueHeight -= 0.05;

        if (redHeight > 1.0) redHeight = 1.0;
        if (blueHeight < 0.0) blueHeight = 0.0;
      });
      if (redHeight >= 1.0) {
        _showWinnerDialog('Red');
      }
    }
  }

  void _increaseBlue() {
    if (!gameEnded && blueHeight < 1.0 && redHeight > 0.0) {
      setState(() {
        blueHeight += 0.05;
        redHeight -= 0.05;

        if (blueHeight > 1.0) blueHeight = 1.0;
        if (redHeight < 0.0) redHeight = 0.0;
      });
      if (blueHeight >= 1.0) {
        _showWinnerDialog('Blue');
      }
    }
  }

  void _resetGame() {
    setState(() {
      redHeight = 0.5;
      blueHeight = 0.5;
      gameEnded = false;
    });
    Navigator.of(context).pop(); // Close the winner dialog
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Red field
          Expanded(
            flex: (redHeight * 100).toInt(),
            child: GestureDetector(
              onTap: _increaseRed,
              child: Container(color: Colors.red),
            ),
          ),
          // Blue field
          Expanded(
            flex: (blueHeight * 100).toInt(),
            child: GestureDetector(
              onTap: _increaseBlue,
              child: Container(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
