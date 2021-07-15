import 'dart:math';
import 'package:flutter/material.dart';
import 'package:roll_rush/Util/colors.dart';

class Flare extends StatefulWidget {
  final Offset initialOffset;
  final Size screenSize;


  Flare({Key key, this.initialOffset,this.screenSize})
      : super(key: key);

  @override
  _FlareState createState() => _FlareState();
}

class _FlareState extends State<Flare> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation offsetAnimation;
  Size size;
  double flareSize =0;


  setInitialOffset() {
    flareSize = 1+ Random().nextInt(6).toDouble();
    size = widget.screenSize;
    double xAxis =
        -100 + Random().nextInt(size.width.round() + 100).ceilToDouble();

    double yAxis = Random().nextInt((size.height).round()).ceilToDouble();


    controller =
    new AnimationController(vsync: this, duration: Duration(seconds: 1));
    offsetAnimation = Tween<Offset>(
        begin: widget.initialOffset,
        end: Offset(
            xAxis,
               yAxis))
        .animate(controller);

    controller.forward();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setInitialOffset();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
            animation: controller,
            builder: (context, snapshot) {

              return Transform.translate(
                offset: offsetAnimation.value,
                child: Container(
                  height: flareSize,
                  width: flareSize,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:  primary,
                  ),
                ),
              );
            }),
      ],
    );
  }
}