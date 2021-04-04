import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roll_rush/colors.dart';
import 'package:roll_rush/game_info_controller.dart';

class Home extends StatelessWidget {
  final double yOffset;
  final Function gameStart;

  const Home({Key key, this.yOffset, this.gameStart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
            top: (size.height - yOffset) * .15, left: 20, right: 20),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer(
                builder: (context, watch, child) {
                return Text(
                  '${watch(gameInfoProvider).score}',
                  style: TextStyle(
                      fontSize: (size.height - yOffset) * .3,
                      color: yOffset > 0 ? white : primary),
                );
              }
            ),
            SizedBox(
              height: 10,
            ),
            Consumer(builder: (context, watch, child) {
              return Text(
                watch(gameInfoProvider).newHighScore ? 'NEW BEST!' : '',
                style: TextStyle(
                    fontSize: size.width * .1, color: white.withOpacity(.5)),
              );
            }),
            if (yOffset == 0)
              SizedBox(
                height: size.height * .15,
              ),
            if (yOffset == 0)
              Row(
                children: [
                  Expanded(
                    child: Center(
                        child: Image.asset(
                      'assets/link.png',
                      height: size.width * .1,
                      color: white.withOpacity(.7),
                    )),
                  ),
                  Expanded(
                    child: Center(
                        child: InkWell(
                            onTap: gameStart,
                            child:  Consumer(
                                builder: (context, watch, child) {
                                return Image.asset(
                                  watch(gameInfoProvider).firstPlay ? 'assets/play.png' : 'assets/replay.png',
                                  height: size.width * .15,
                                  color: white.withOpacity(.7),
                                );
                              }
                            ))),
                  ),
                  Expanded(
                    child: Center(
                        child: Image.asset(
                      'assets/volume.png',
                      height: size.width * .1,
                      color: white.withOpacity(.7),
                    )),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
