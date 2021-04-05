import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roll_rush/Util/colors.dart';

class RewardLoader extends StatefulWidget {
  // final Function onCancel;
  // final Function onShowReward;

  const RewardLoader({Key key})
      : super(key: key);

  @override
  _RewardLoaderState createState() => _RewardLoaderState();
}

class _RewardLoaderState extends State<RewardLoader>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation progressAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        new AnimationController(vsync: this, duration: Duration(seconds: 4));
    progressAnimation = Tween<double>(begin: 0, end: 1).animate(controller);
    controller.addListener(() {
      if(controller.isCompleted){
        Navigator.pop(context,false);
      }
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return Future.value(false);
      },
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: black.withOpacity(.15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      return Container(
                        height: 170,
                        width: 170,
                        child: CircularProgressIndicator(
                          strokeWidth: 10,
                          value: progressAnimation.value,
                          backgroundColor: black.withOpacity(.5),
                          valueColor: AlwaysStoppedAnimation(white.withOpacity(.2)),
                        ),
                      );
                    }),
                Positioned(
                  top: 0,right: 0,left: 0,bottom: 0,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Continue',
                          style: TextStyle(
                              color: white.withOpacity(.8), fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                        SizedBox(height: 15,),
                        ElevatedButton(
                            onPressed: () {
                              controller.stop();
                              // widget.onCancel();
                              Navigator.pop(context,true);
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: primary,
                                shape: StadiumBorder()),
                            child: Text(
                              'Watch video',
                              style: TextStyle(
                                  color: white, fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  controller.stop();
                  // widget.onCancel();
                  Navigator.pop(context,false);
                },
                style: TextButton.styleFrom(
                    backgroundColor: white.withOpacity(.2),
                    shape: StadiumBorder()),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9.0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: white.withOpacity(.8), fontWeight: FontWeight.w400,
                    fontSize: 15),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
