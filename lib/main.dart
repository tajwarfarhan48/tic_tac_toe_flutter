import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Tic Tac Toe",
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: Builder(
            builder: (BuildContext context) => Scaffold(
                appBar: AppBar(title: const Text('Tic-Tac-Toe')),
                body: const GameArea())));
  }
}

class GameArea extends StatefulWidget {
  const GameArea({Key? key}) : super(key: key);

  @override
  _GameAreaState createState() => _GameAreaState();
}

class _GameAreaState extends State<GameArea> {
  final List<List<int>> _scoreGrid = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0]
  ];
  final List<int> _flattenedScoreGrid = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  bool _pOneTurn = true;
  bool _pOneWin = false;
  bool _pTwoWin = false;
  bool _draw = false;
  int _pOnePoints = 0;
  int _pTwoPoints = 0;

  // ---------------- GAME METHODS START ---------------- //
  /* GAME METHODS RUN EVERY TIME THE USER INTERACTS WITH A UI ELEMENT IN THE GAME AREA (THE GRID OR THE RESET BUTTONS). */

  void updateFlattenedGrid() {
    /* THIS FUNCTION UPDATES THE VALUE OF THE FLATTENED GRID AFTER CHANGES TO THE MAIN GRID */

    for (int i = 0; i < 9; i++) {
      _flattenedScoreGrid[i] = _scoreGrid[i ~/ 3][i % 3];
    }
  }

  void touchGridAt(int i, int j) {
    /* DEFINES THE CORRESPONDING CHANGE TO THE SCORE GRID AND THE FLATTENED GRID WHEN THE PLAYER TOUCHES THE VISUAL GRID AT INDEX (i, j)  */

    if (_scoreGrid[i][j] != 0) {
      return;
    }

    if (_pOneTurn) {
      _scoreGrid[i][j] = 1;
    } else {
      _scoreGrid[i][j] = 2;
    }

    _pOneTurn = !_pOneTurn;
    checkVictoryOrDraw();
    updateFlattenedGrid();
  }

  void resetGrid() {
    /* RESETS THE MAIN GRID, CURRENT GAME INFORMATION, AND THE FLATTENED GRID TO THE ORIGINAL CONFIGURATION */

    int i;
    int j;

    for (i = 0; i < 3; i++) {
      for (j = 0; j < 3; j++) {
        _scoreGrid[i][j] = 0;
      }
    }

    _pOneWin = false;
    _pTwoWin = false;
    _draw = false;
    _pOneTurn = true;

    updateFlattenedGrid();
  }

  void resetPoints() {
    /* RESETS THE POINT COUNT AND STARTS A NEW GAME */

    _pOnePoints = 0;
    _pTwoPoints = 0;

    resetGrid();
  }

  void setVictoryGrid(int victoryMarker, List<List<int>> listIndices) {
    /* SETS ALL THE 0 VALUES IN THE GRID TO -1S, AND UPDATES THE REST OF THE VALUES IN THE GRID ACCORDING TO victoryMarker.
        - IF victoryMarker IS 3, ALL 1S IN THE GRID GET SET TO 3S
        - IF victoryMarker IS 4, ALL 2S IN THE GRID GET SET TO 4S
       AFTER UPDATING THE MAIN GRID VALUES, IT UPDATES THE PLAYER SCORES AND THE FLATTENED GRID */

    int i;
    int j;

    for (i = 0; i < 3; i++) {
      for (j = 0; j < 3; j++) {
        if (_scoreGrid[i][j] == 0) {
          _scoreGrid[i][j] = -1;
        } else if ((victoryMarker == 3) &&
            (_scoreGrid[i][j] == 1) &&
            (listContains(listIndices, [i,j]))) {
          _scoreGrid[i][j] = 3;
        } else if ((victoryMarker == 4) &&
            (_scoreGrid[i][j] == 2) &&
            (listContains(listIndices, [i,j]))) {
          _scoreGrid[i][j] = 4;
        }
      }
    }

    if (victoryMarker == 3) {
      _pOneWin = true;
      _pOnePoints++;
    } else {
      _pTwoWin = true;
      _pTwoPoints++;
    }

    updateFlattenedGrid();
  }

  void checkVictoryOrDraw() {
    /* CHECKS WHETHER PLAYER ONE OR TWO HAS WON. IF SO, IT ACCORDINGLY SETS UP THE VICTORY GRID */

    int i;
    int j;

    for (i = 0; i < 3; i++) {
      if ((_scoreGrid[i][0] == 1) &&
          (_scoreGrid[i][1] == 1) &&
          (_scoreGrid[i][2] == 1)) {
        setVictoryGrid(3, [
          [i, 0],
          [i, 1],
          [i, 2]
        ]);
        return;
      } else if ((_scoreGrid[i][0] == 2) &&
          (_scoreGrid[i][1] == 2) &&
          (_scoreGrid[i][2] == 2)) {
        setVictoryGrid(4, [
          [i, 0],
          [i, 1],
          [i, 2]
        ]);
        return;
      } else if ((_scoreGrid[0][i] == 1) &&
          (_scoreGrid[1][i] == 1) &&
          (_scoreGrid[2][i] == 1)) {
        setVictoryGrid(3, [
          [0, i],
          [1, i],
          [2, i]
        ]);
        return;
      } else if ((_scoreGrid[0][i] == 2) &&
          (_scoreGrid[1][i] == 2) &&
          (_scoreGrid[2][i] == 2)) {
        setVictoryGrid(4, [
          [0, i],
          [1, i],
          [2, i]
        ]);
        return;
      }
    }

    if ((_scoreGrid[0][0] == 1) &&
        (_scoreGrid[1][1] == 1) &&
        (_scoreGrid[2][2] == 1)) {
      setVictoryGrid(3, [
        [0, 0],
        [1, 1],
        [2, 2]
      ]);
      return;
    } else if ((_scoreGrid[0][0] == 2) &&
        (_scoreGrid[1][1] == 2) &&
        (_scoreGrid[2][2] == 2)) {
      setVictoryGrid(4, [
        [0, 0],
        [1, 1],
        [2, 2]
      ]);
      return;
    } else if ((_scoreGrid[0][2] == 1) &&
        (_scoreGrid[1][1] == 1) &&
        (_scoreGrid[2][0] == 1)) {
      setVictoryGrid(3, [
        [0, 2],
        [1, 1],
        [2, 0]
      ]);
      return;
    } else if ((_scoreGrid[0][2] == 2) &&
        (_scoreGrid[1][1] == 2) &&
        (_scoreGrid[2][0] == 2)) {
      setVictoryGrid(4, [
        [0, 2],
        [1, 1],
        [2, 0]
      ]);
      return;
    }

    for (i = 0; i < 3; i++) {
      for (j = 0; j < 3; j++) {
        if (_scoreGrid[i][j] == 0) {
          return;
        }
      }
    }

    _draw = true;
    return;
  }

  // ---------------- GAME METHODS END ---------------- //

  // ---------------- DISPLAY METHODS START ---------------- //
  /* DISPLAY METHODS RENDER THE VARIOUS UI ELEMENTS IN THE GAME */

  TextStyle topTextStyle(int playerNum) {
    /* RETURNS THE TEXT STYLE FOR THE TEXT AT THE TOP OF THE SCREEN DEPENDING ON THE PLAYER WHOSE TURN IT IS.
       - playerNum = 3 INDICATES A DRAW */

    if (playerNum == 1) {
      return TextStyle(
          color: Colors.blueGrey[700],
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto');
    } else if (playerNum == 2) {
      return TextStyle(
          color: Colors.indigo[900],
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto');
    } else {
      return const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto');
    }
  }

  Center topText() {
    /* RETURNS THE WIDGET FOR THE TEXT THAT SHOWS UP AT THE TOP OF THE SCREEN, SIGNALLING THE CURRENT PLAYER's TURN OR A PLAYER'S VICTORY */

    if (_pOneWin) {
      return Center(
          child: Text("Congratulations, Player 1 has won!",
              style: topTextStyle(1)));
    } else if (_pTwoWin) {
      return Center(
          child: Text("Congratulations, Player 2 has won!",
              style: topTextStyle(2)));
    } else if (_draw) {
      return Center(child: Text("Match Drawn.", style: topTextStyle(3)));
    } else if (_pOneTurn) {
      return Center(child: Text("Player 1's Turn", style: topTextStyle(1)));
    } else {
      return Center(child: Text("Player 2's Turn", style: topTextStyle(2)));
    }
  }

  SizedBox visualGrid() {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox.square(
        dimension: screenWidth,
        child: Container(
            color: Colors.black,
            width: screenWidth,
            height: screenWidth,
            child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                children: [
                  getStack(0, 0),
                  getStack(0, 1),
                  getStack(0, 2),
                  getStack(1, 0),
                  getStack(1, 1),
                  getStack(1, 2),
                  getStack(2, 0),
                  getStack(2, 1),
                  getStack(2, 2)
                ])));
  }

  Widget getStack(int i, int j, {Key? key}) {
    /* RETURNS THE WIDGET FOR THE APPROPRIATE STACK BASED ON THE TYPE */

    int type = _scoreGrid[i][j];

    switch (type) {
      case -1:
        return Container(color: const Color.fromRGBO(250, 250, 250, 1.0));

      case 0:
        return GestureDetector(
            child: Container(color: const Color.fromRGBO(250, 250, 250, 1.0)),
            onTap: () {
              setState(() {
                touchGridAt(i, j);
              });
            });

      case 1:
        return Container(
            color: const Color.fromRGBO(250, 250, 250, 1.0),
            child: Center(
                child:
                    Icon(Icons.close, color: Colors.blueGrey[700], size: 70)));

      case 2:
        return Container(
            color: const Color.fromRGBO(250, 250, 250, 1.0),
            child: Center(
                child:
                    Icon(Icons.circle, color: Colors.indigo[900], size: 60)));

      case 3:
        return Container(
            color: const Color.fromRGBO(250, 250, 250, 1.0),
            child: const Center(
                child: Icon(Icons.close, color: Colors.red, size: 70)));

      case 4:
        return Container(
            color: const Color.fromRGBO(250, 250, 250, 1.0),
            child: const Center(
                child: Icon(Icons.circle, color: Colors.red, size: 60)));

      default:
        return Container(color: const Color.fromRGBO(250, 250, 250, 1.0));
    }
  }

  var pointsRowTextStyle = const TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 15,
      fontFamily: 'Roboto',
      color: Colors.grey);

  Container pointsRowText() {
    return Container(
        padding: const EdgeInsets.all(5),
        child: DefaultTextStyle.merge(
            style: pointsRowTextStyle,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Player 1 Points: " + _pOnePoints.toString()),
                  Text("Player 2 Points: " + _pTwoPoints.toString())
                ])));
  }

  Container resetPointsButton() {
    return Container(
        width: 160,
        height: 90,
        padding: const EdgeInsets.all(5),
        child: TextButton(
            child: const Text("Reset Points"),
            onPressed: () {
              setState(() {
                resetPoints();
              });
            }));
  }

  Container resetRoundButton() {
    if ((_pOneWin) || (_pTwoWin) || (_draw)) {
      return Container(
          width: 160,
          height: 90,
          padding: const EdgeInsets.all(5),
          child: TextButton(
              child: const Text("New Match"),
              onPressed: () {
                setState(() {
                  resetGrid();
                });
              }));
    }

    return Container(
        width: 160,
        height: 90,
        padding: const EdgeInsets.all(5),
        child: TextButton(
            child: const Text("Restart"),
            onPressed: () {
              setState(() {
                resetGrid();
              });
            }));
  }

  Container buttonRow() {
    return Container(
        padding: const EdgeInsets.all(5),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [resetPointsButton(), resetRoundButton()]));
  }

  // ---------------- DISPLAY METHODS END ---------------- //

  // ---------------- HELPER METHODS START ---------------- //
  /* METHODS DESIGNED TO HELP WITH MENIAL TASKS */

  bool listContains(List<List<int>> list1, List<int> list2) {
    /* CHECKS WHETHER A LIST OF LISTS CONTAINS A LIST */

    for (int i = 0; i < list1.length; i++) {
      if (listEquals(list1[i], list2)) {
        return true;
      }
    }

    return false;
  }

  bool listEquals(List<int> list1, List<int> list2) {
    /* CHECKS WHETHER TWO LISTS ARE EQUAL (HAVE THE SAME LENGTH AND CONTAIN THE SAME ITEMS AT ALL INDICES) */

    if (list1.length != list2.length) {
      return false;
    }

    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }

    return true;
  }

  // ---------------- HELPER METHODS END ---------------- //

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      Expanded(flex: 1, child: topText()),
      visualGrid(),
      Expanded(flex: 1, child: pointsRowText()),
      Expanded(flex: 1, child: buttonRow())
    ]);
  }

}
