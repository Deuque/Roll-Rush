import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:roll_rush/Controller/game_info_controller.dart';
import 'package:roll_rush/Util/colors.dart';

enum XAxisDirection { postive, negative }
enum BoxAction { add1Point, add2Points, add3Points, remove2Points, remove3Points, addExtraLife, kill}

class FallingBox extends StatefulWidget {
  final Function(Offset x, int index, BoxAction boxAction, double boxSize) checkOffset;
  final int index;
  final Size screenSize;
  final bool startedPlaying;

  FallingBox({Key key, this.checkOffset, this.index, this.screenSize, this.startedPlaying})
      : super(key: key);

  @override
  _FallingBoxState createState() => _FallingBoxState();
}

class _FallingBoxState extends State<FallingBox> with TickerProviderStateMixin {
  Offset offset;
  XAxisDirection direction;
  AnimationController controller, controller2;
  Animation offsetAnimation;
  Animation rotationAnimation;
  Size size;
  Color color;
  double boxSize = 37;
  int duration = 3000;
  BoxAction boxAction;
  bool star = false;
  String boxText = '';

  setBoxProperties(){
    if(widget.index < 40 || !widget.startedPlaying){

      color = Random().nextInt(4) == 1 ? primary : white;
      boxAction = color == white ? BoxAction.kill : BoxAction.add1Point;


    }else if((widget.index%40)==0){

      star = true;
      boxAction = BoxAction.addExtraLife;
      duration = 1500;

    } else if(widget.index > 40 && widget.index < 120){

      color = Random().nextInt(4) == 1 ? primary : white;
      if(color == primary){
        if(Random().nextInt(4) == 1){
          boxSize = (50+Random().nextInt(15)).toDouble();
          boxAction = BoxAction.add2Points;
          boxText = '+2';
          duration = 2000;
        }else{
          boxAction = BoxAction.add1Point;
        }
      }else{
        if(Random().nextInt(3) == 1){
          boxSize = (50+Random().nextInt(15)).toDouble();
          boxAction = BoxAction.remove2Points;
          boxText = '-2';
          duration = 2000;
        }else{
          boxAction = BoxAction.kill;
        }
      }

    }else{

      color = Random().nextInt(4) == 1 ? primary : white;
      if(color == primary){
        if(Random().nextInt(4) == 1){
          boxSize = (50+Random().nextInt(40)).toDouble();
          boxAction = boxSize <= 65 ? BoxAction.add2Points : BoxAction.add3Points;
          boxText = boxSize <= 65 ? '+2' : '+3';
          duration =  2000;
        }else{
          boxAction = BoxAction.add1Point;
        }
      }else{
        if(Random().nextInt(3) == 1){
          boxSize = (50+Random().nextInt(40)).toDouble();
          boxAction = boxSize <= 65 ? BoxAction.remove2Points : BoxAction.remove3Points;
          boxText = boxSize <= 65 ? '-2' : '-3';
          duration =  2000;
        }else{
          boxAction = BoxAction.kill;
        }
      }

    }
  }

  setInitialOffset() {
    // List colors = [white, primary, white, white];
    // color = Random().nextInt(4) == 1 ? primary : white;
    // boxSize = color == primary
    //     ? 37
    //     : context.read(gameInfoProvider).level == 1
    //         ? 37
    //         : context.read(gameInfoProvider).level == 2
    //             ? Random().nextInt(4) == 1
    //                 ? (40 + Random().nextInt(25)).toDouble()
    //                 : 37
    //             : Random().nextInt(4) == 1
    //                 ? (50 + Random().nextInt(40)).toDouble()
    //                 : 37;
    //print(boxSize);

    setBoxProperties();
    size = widget.screenSize;
    double xAxis =
        -100 + Random().nextInt(size.width.round() + 100).ceilToDouble();
    double yAxis = Random().nextInt((size.height * .1).round()).ceilToDouble();

    offset = Offset(xAxis, 0);
    direction = xAxis < size.width / 2
        ? XAxisDirection.postive
        : XAxisDirection.negative;

    controller =
        new AnimationController(vsync: this, duration: Duration(milliseconds: duration));
    controller2 =
        new AnimationController(vsync: this, duration: Duration(seconds: 12));
    offsetAnimation = Tween<Offset>(
            begin: offset,
            end: Offset(
                direction == XAxisDirection.postive
                    ? (size.width / 2) + ((size.width / 2) - offset.dx)
                    : (size.width / 2) - (offset.dx - (size.width / 2)),
                size.height * .7))
        .animate(controller);
    rotationAnimation = Tween<double>(
            begin: 0,
            end: direction == XAxisDirection.postive ? -2 * pi : 2 * pi)
        .animate(controller2);

    controller.addListener(() {
      widget.checkOffset(offsetAnimation.value, widget.index, boxAction, boxSize);
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
                  child: star ? Image.asset('assets/star.png',height: boxSize,width: boxSize,) : Container(
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                        color: color,
                      borderRadius: BorderRadius.circular((Random().nextInt(4)).toDouble())
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      boxText,
                      style: TextStyle(
                        color: color==primary ? white : dark,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ),
              );
            }),
      ],
    );
  }
}
