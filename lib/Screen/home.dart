import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:roll_rush/Controller/game_info_controller.dart';
import 'package:roll_rush/Util/colors.dart';
import 'package:roll_rush/Widget/star_life.dart';
import 'package:share/share.dart';

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
            if(yOffset==0)
              Center(child: StarLife()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                if(yOffset >size.width/2)
                  Padding(
                    padding: const EdgeInsets.only(left:20.0),
                    child: StarLife(),
                  )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            if (yOffset == 0)
              Consumer(builder: (context, watch, child) {
                return Text(
                  watch(gameInfoProvider).newHighScore ? 'NEW BEST!' : watch(gameInfoProvider).bestScore>0?'BEST ${watch(gameInfoProvider).bestScore}':'',
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
                        child: InkWell(
                          customBorder: CircleBorder(),
                          onTap: () =>Share.share('Check out https://play.google.com/store/apps/details?id=com.dcdevs.roll_rush', subject: 'Can you beat my score?'),
                          child: Image.asset(
                      'assets/link.png',
                      height: size.width * .1,
                      color: white.withOpacity(.7),
                    ),
                        )),
                  ),
                  Expanded(
                    child: Center(
                        child: InkWell(
                            customBorder: CircleBorder(),
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
                        child: InkWell(
                          customBorder: CircleBorder(),
                          onTap: (){
                            context.read(gameInfoProvider).toggleSpeaker();
                          },
                          child: Consumer(
                              builder: (context, watch, child) {
                              return Image.asset(
                                watch(gameInfoProvider).speakerOn ? 'assets/volume.png': 'assets/volume_off.png',
                      height: size.width * .1,
                      color: white.withOpacity(.7),
                    );
                            }
                          ),
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
