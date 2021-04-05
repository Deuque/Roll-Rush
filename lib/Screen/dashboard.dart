import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:roll_rush/Controller/game_info_controller.dart';
import 'package:roll_rush/Screen/game_area.dart';
import 'package:roll_rush/Screen/home.dart';
import 'package:roll_rush/Widget/reward_loader.dart';

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
  bool rewardAdsGotten=false;
   RewardedAd myRewarded;

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

    // myRewarded = RewardedAd.fromPublisherRequest(
    //   adUnitId: '/6499/example/rewarded',
    //   publisherRequest: PublisherAdRequest(),
    //   listener: AdListener(
    //     // Called when an ad is successfully received.
    //     onAdLoaded: (Ad ad) => print('Ad loaded.'),
    //     // Called when an ad request failed.
    //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
    //       ad.dispose();
    //       print('Ad failed to load: $error');
    //     },
    //     // Called when an ad opens an overlay that covers the screen.
    //     onAdOpened: (Ad ad) => print('Ad opened.'),
    //     // Called when an ad removes an overlay that covers the screen.
    //     onAdClosed: (Ad ad) {
    //       ad.dispose();
    //       print('Ad closed.');
    //     },
    //     // Called when an ad is in the process of leaving the application.
    //     onApplicationExit: (Ad ad) => print('Left application.'),
    //     // Called when a RewardedAd triggers a reward.
    //     onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
    //       print('Reward earned: $reward');
    //       setState(() {
    //         rewardAdsGotten = true;
    //       });
    //     },
    //   ),
    // );
    //myRewarded.load();
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
                        key: Key((offsetAnimation2.value == 0).toString()+rewardAdsGotten.toString()),
                        screenSize: size,
                        gameInView: offsetAnimation2.value == 0,
                        gameEnd: () async {

                          controller.reverse();
                          context.read(gameInfoProvider).gameEnded();
                          return Future.value(false);

                          if (context.read(gameInfoProvider).seenRewardAds) {
                            controller.reverse();
                            context.read(gameInfoProvider).gameEnded();
                            return Future.value(false);
                          }

                          if(!(await myRewarded.isLoaded())){
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
                          } else {
                             myRewarded.show();
                          }

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
