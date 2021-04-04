import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roll_rush/Controller/game_info_controller.dart';
import 'package:roll_rush/Screen/game_area.dart';
import 'package:roll_rush/Screen/home.dart';
import 'package:roll_rush/widgets/reward_loader.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation offsetAnimation;
  Animation offsetAnimation2;
  bool showRewardAd = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 700));
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
                        gameEnd: () async {
                          // setState(() {
                          //   showRewardAd = true;
                          // });
                          if (context.read(gameInfoProvider).seenRewardAds) {
                            controller.reverse();
                            context.read(gameInfoProvider).gameEnded();
                            return Future.value(false);
                          }

                          context.read(gameInfoProvider).toggleSeenRewardAds();

                          var response = await showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                    insetPadding: EdgeInsets.zero,
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    child: RewardLoader(),
                                  ));

                          if (!response) {
                            controller.reverse();
                            context.read(gameInfoProvider).gameEnded();
                          } else {}

                          return response;
                        })),
                Transform.translate(
                    offset: Offset(0.0, size.height * offsetAnimation.value),
                    child: Home(
                        yOffset: size.height * offsetAnimation.value,
                        gameStart: () {
                          controller.forward();
                          context.read(gameInfoProvider).gameStarted();
                        })),
              ],
            );
          }),
    );
  }
}
