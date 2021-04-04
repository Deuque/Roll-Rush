import 'package:flutter/material.dart';
import 'package:roll_rush/game_area.dart';
import 'package:roll_rush/game_info_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roll_rush/home.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation offsetAnimation;
  Animation offsetAnimation2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
    new AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    offsetAnimation = Tween<double>(begin: 0, end: .65).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutCirc));
    offsetAnimation2 = Tween<double>(begin: -0.4, end: 0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutCirc));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: [
                Transform.translate(
                    offset: Offset(0.0, size.height * offsetAnimation2.value),
                    child: GameArea(
                        key: Key((offsetAnimation2.value == 0).toString()),
                        screenSize: size,
                        gameInView: offsetAnimation2.value == 0,
                        gameEnd: (){
                          controller.reverse();
                          context.read(gameInfoProvider).gameEnded();
                        }
                    )),
                Transform.translate(
                    offset: Offset(0.0, size.height * offsetAnimation.value),
                    child: Home(
                        yOffset: size.height * offsetAnimation.value,
                        gameStart: (){
                          controller.forward();
                          context.read(gameInfoProvider).gameStarted();
                        }
                    ))
              ],
            );
          }),
    );
  }
}