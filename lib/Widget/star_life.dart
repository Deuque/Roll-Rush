import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roll_rush/Controller/game_info_controller.dart';
import 'package:roll_rush/Util/colors.dart';
class StarLife extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.6,end: 1),
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 500),
      builder: (context, val, child) {
        return Opacity(
          opacity: val,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/star.png',height: 18,),
              SizedBox(width: 6,),
              Consumer(
                builder:(_,watch,child){
                  return Text(
                    '${watch(gameInfoProvider).lives}',
                    style: TextStyle(
                      color: white.withOpacity(.6),
                      fontSize: 18
                    ),
                  );
                }
              )
            ],
          ),
        );
      }
    );
  }
}
