import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:roll_rush/Controller/game_info_controller.dart';
import 'package:roll_rush/Util/colors.dart';
import 'package:roll_rush/Util/helper_functions.dart';
import 'package:roll_rush/Widget/falling_box.dart';
import 'package:roll_rush/Widget/flare.dart';
import 'package:roll_rush/main.dart';

class GameArea extends StatefulWidget {
  final Size screenSize;
  final bool gameInView;
  final Future Function() possibleGameEnd;

  const GameArea({Key key, this.screenSize, this.gameInView, this.possibleGameEnd})
      : super(key: key);

  @override
  _GameAreaState createState() => _GameAreaState();
}

class _GameAreaState extends State<GameArea> with WidgetsBindingObserver {
  List<Widget> children = [];
  int countFromStartPlaying = 0;
  List<Widget> flares = [];

  List<int> checkingIndexes = [];
  List<int> gottenIndexes = [];
  StreamController boxesController = new StreamController();
  StreamController flareController = new StreamController();

  Timer ballTimer;
  GlobalKey _ballKey = GlobalKey();
  Offset ballOffset;
  Color ballColor = primary;
  double ballSize = 42;
  double ballFieldHeight = 42;
  double ballTimelyOffset = Platform.isIOS ? 1.2 : 0.415;
  int ballOffsetDuration = 1;
  double ballFieldBegin = 0.1;
  double ballFieldEnd = 0.9;

  bool paused = false;
  Timer boxTimer;

  @override
  void dispose() {
    // TODO: implement dispose
    boxesController.close();
    flareController.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && !paused) {
      pauseGame();
    }
    // if (state == AppLifecycleState.resumed) {
    //   setFallingBoxesTimer();
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setFallingBoxTimer();
  }

  setFallingBoxTimer() {
    if (!widget.gameInView) ballSize = 0;
    if (widget.gameInView) {
      //ballSize = 42;
      boxTimer = Timer.periodic(Duration(milliseconds: 800), (Timer t) {
        children.add(new FallingBox(
          key: Key(children.length.toString()),
          checkOffset: checkOffset,
          index: children.length,
          screenSize: widget.screenSize,
          startedPlaying: ballOffset != null,
        ));
        //print(children.length);
        // if(ballOffset!=null) countFromStartPlaying++;
        // if(countFromStartPlaying==200){
        //   context.read(gameInfoProvider).incrementLevel();
        // }else if(countFromStartPlaying==400){
        //   context.read(gameInfoProvider).incrementLevel();
        // }
        boxesController.sink.add(children);
      });
    }
  }

  pauseGame() {
    if (boxTimer != null && boxTimer.isActive) boxTimer.cancel();
    if (ballTimer != null && ballTimer.isActive) ballTimer.cancel();
    ballSize = 0;
    checkingIndexes=[];
    setState(() {
      paused = true;
    });
  }

  continueGame() {
    setState(() {
      paused = false;
      ballSize=42;
    });
    setFallingBoxTimer();
  }

  checkOffset(Offset x, int index, BoxAction boxAction, double boxSize) {
    if (x == null ||
        ballOffset == null ||
        paused ||
        checkingIndexes.contains(index)) return;
    final position1 = x;
    final position2 = ballOffset;
    double s1 = boxSize;
    double s2 = ballSize - 5;

    final collide = (position1.dx < position2.dx + s2 &&
        position1.dx + s1 > position2.dx &&
        position1.dy < position2.dy + s2 - 5 &&
        position1.dy + s1 > position2.dy);
    checkingIndexes.add(index);
    setState(() {});
    if (collide) {
      // mcolor = color;
      gottenIndexes.add(index);
      if (boxAction != BoxAction.kill) {
        if (boxAction == BoxAction.add1Point) {
          playSound('score.mp3', context);
          context.read(gameInfoProvider).incrementScore(1);
        } else if (boxAction == BoxAction.add2Points) {
          playSound('score.mp3', context);
          context.read(gameInfoProvider).incrementScore(2);
        } else if (boxAction == BoxAction.add3Points) {
          playSound('score.mp3', context);
          context.read(gameInfoProvider).incrementScore(3);
        } else if (boxAction == BoxAction.remove2Points) {
          playSound('end.wav', context);
          flareController.sink.add(List<Widget>.generate(
              4,
              (index) => Flare(
                    initialOffset: ballOffset,
                    screenSize: widget.screenSize,
                  )));
          Future.delayed(Duration(seconds: 1), () {
            flareController.sink.add(<Widget>[]);
          });
          context.read(gameInfoProvider).decrementScore(2);
        } else if (boxAction == BoxAction.remove3Points) {
          playSound('end.wav', context);
          flareController.sink.add(List<Widget>.generate(
              7,
              (index) => Flare(
                    initialOffset: ballOffset,
                    screenSize: widget.screenSize,
                  )));
          Future.delayed(Duration(seconds: 1), () {
            flareController.sink.add(<Widget>[]);
          });
          context.read(gameInfoProvider).decrementScore(3);
        } else if (boxAction == BoxAction.addExtraLife) {
          playSound('score.mp3', context);
          context.read(gameInfoProvider).incrementLives();
        }
      } else {
        pauseGame();
        playSound('end.wav', context);
        flareController.sink.add(List<Widget>.generate(
            30,
            (index) => Flare(
                  initialOffset: ballOffset,
                  screenSize: widget.screenSize,
                )));

        Future.delayed(Duration(seconds: 1), () {
          flareController.sink.add(<Widget>[]);

          widget.possibleGameEnd();
        });
      }
      setState(() {});
    } else {
      checkingIndexes.removeWhere((element) => element == index);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //ballTimelyOffset = size.width*.001;
    return GestureDetector(
      onTapDown: (details) {
        if(paused) return;
        playSound('tap.wav', context);
        ballOffset = ballOffset ?? _ballKey.globalPaintBounds.topLeft;
        bool right;
        if (details.globalPosition.dx > size.width / 2) {
          right = true;
        } else {
          right = false;
        }

        if(ballTimer!=null && ballTimer.isActive)ballTimer.cancel();
        if (right) {
          ballTimer = Timer.periodic(Duration(milliseconds: ballOffsetDuration),
              (Timer t) {
            if (right) {
              if (ballOffset.dx < size.width * ballFieldEnd - ballSize) {
                ballOffset =
                    Offset(ballOffset.dx + ballTimelyOffset, ballOffset.dy);
              } else {
                right = false;
                ballOffset =
                    Offset(ballOffset.dx - ballTimelyOffset, ballOffset.dy);
              }
            } else {
              if (ballOffset.dx > size.width * ballFieldBegin) {
                ballOffset =
                    Offset(ballOffset.dx - ballTimelyOffset, ballOffset.dy);
              } else {
                right = true;
                ballOffset =
                    Offset(ballOffset.dx + ballTimelyOffset, ballOffset.dy);
              }
            }
            if (mounted) setState(() {});
          });
        } else {
          ballTimer = Timer.periodic(Duration(milliseconds: ballOffsetDuration),
              (Timer t) {
            if (!right) {
              if (ballOffset.dx > size.width * ballFieldBegin) {
                ballOffset =
                    Offset(ballOffset.dx - ballTimelyOffset, ballOffset.dy);
              } else {
                right = true;
                ballOffset =
                    Offset(ballOffset.dx + ballTimelyOffset, ballOffset.dy);
              }
            } else {
              if (ballOffset.dx < size.width * ballFieldEnd - ballSize) {
                ballOffset =
                    Offset(ballOffset.dx + ballTimelyOffset, ballOffset.dy);
              } else {
                right = false;
                ballOffset =
                    Offset(ballOffset.dx - ballTimelyOffset, ballOffset.dy);
              }
            }
            if (mounted) setState(() {});
          });
        }
      },
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              // Positioned(
              //     top: 0,
              //     left: 0,
              //     right: 0,
              //     bottom: 0,
              //     child: Image.asset(
              //       'assets/bg.jpg',
              //       fit: BoxFit.cover,
              //     )),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: StreamBuilder(
                  stream: boxesController.stream,
                  builder: (_, snap) {
                    List<Widget> newlist = [];
                    if (snap.hasData) {
                      newlist = (snap.data as List)
                          .where((element) => !gottenIndexes
                              .contains(snap.data.indexOf(element)))
                          .toList();
                    }
                    return Stack(
                      children: newlist,
                    );
                  },
                ),
              ),
              Positioned(
                top: size.height * .65,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: dark,
                ),
              ),
              Positioned(
                top: size.height * .55,
                left: size.width * ballFieldBegin,
                right: size.width * ballFieldBegin,
                child: Container(
                  width: double.infinity,
                  height: ballFieldHeight,
                  decoration: BoxDecoration(
                    color: black.withOpacity(.15),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              Transform.translate(
                offset: ballOffset ??
                    Offset(size.width / 2 - (ballSize / 2), size.height * .55),
                child: Container(
                  key: _ballKey,
                  height: ballSize,
                  width: ballSize,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: ballColor),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: StreamBuilder(
                  stream: flareController.stream,
                  builder: (_, snap) {
                    return !snap.hasData
                        ? SizedBox(
                            height: 0,
                          )
                        : Stack(
                            children: snap.data,
                          );
                  },
                ),
              ),
              Positioned(
                top: size.height * .67,
                left: 0,
                right: 0,
                child: Center(
                    child: InkWell(
                        customBorder: CircleBorder(),
                        onTap: paused
                            ? () {
                                continueGame();
                              }
                            : () {
                                pauseGame();
                              },
                        child: Image.asset(
                          paused ? 'assets/play.png' : 'assets/pause.png',
                          height: size.width * .075,
                          color: white.withOpacity(.7),
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
