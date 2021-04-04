import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:roll_rush/Controller/game_info_controller.dart';
import 'package:roll_rush/Util/colors.dart';

enum xAxisDirection { postive, negative }

class FallingBox extends StatefulWidget {
  final Function(Offset x, int index, Color color, double boxSize) checkOffset;
  final int index;
  final Size screenSize;

  FallingBox({Key key, this.checkOffset, this.index, this.screenSize})
      : super(key: key);

  @override
  _FallingBoxState createState() => _FallingBoxState();
}

class _FallingBoxState extends State<FallingBox> with TickerProviderStateMixin {
  Offset offset;
  xAxisDirection direction;
  AnimationController controller, controller2;
  Animation offsetAnimation;
  Animation rotationAnimation;
  Size size;
  Color color;
  double boxSize;

  setInitialOffset() {
    // List colors = [white, primary, white, white];
    color = Random().nextInt(4) == 1 ? primary : white;
    boxSize = color == primary
        ? 37
        : context.read(gameInfoProvider).level == 1
            ? 37
            : context.read(gameInfoProvider).level == 2
                ? Random().nextInt(4) == 1
                    ? (40 + Random().nextInt(25)).toDouble()
                    : 37
                : Random().nextInt(4) == 1
                    ? (50 + Random().nextInt(40)).toDouble()
                    : 37;
    //print(boxSize);
    size = widget.screenSize;
    double xAxis =
        -100 + Random().nextInt(size.width.round() + 100).ceilToDouble();
    double yAxis = Random().nextInt((size.height * .1).round()).ceilToDouble();

    offset = Offset(xAxis, 0);
    direction = xAxis < size.width / 2
        ? xAxisDirection.postive
        : xAxisDirection.negative;

    controller =
        new AnimationController(vsync: this, duration: Duration(seconds: 3));
    controller2 =
        new AnimationController(vsync: this, duration: Duration(seconds: 12));
    offsetAnimation = Tween<Offset>(
            begin: offset,
            end: Offset(
                direction == xAxisDirection.postive
                    ? (size.width / 2) + ((size.width / 2) - offset.dx)
                    : (size.width / 2) - (offset.dx - (size.width / 2)),
                size.height * .7))
        .animate(controller);
    rotationAnimation = Tween<double>(
            begin: 0,
            end: direction == xAxisDirection.postive ? -2 * pi : 2 * pi)
        .animate(controller2);

    controller.addListener(() {
      widget.checkOffset(offsetAnimation.value, widget.index, color, boxSize);
    });
    controller.forward();

    controller2.forward();
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
    controller2?.dispose();
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
                child: Transform.rotate(
                  angle: rotationAnimation.value,
                  child: Container(
                    height: boxSize,
                    width: boxSize,
                    color: color,
                  ),
                ),
              );
            }),
      ],
    );
  }
}
