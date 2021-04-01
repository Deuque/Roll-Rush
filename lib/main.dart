import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/screenutil_init.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        // designSize: Size(360, 690),
        // allowFontScaling: false,
        builder: () {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BoxContainers(),
      );
    });
  }
}

class BoxContainers extends StatefulWidget {
  @override
  _BoxContainersState createState() => _BoxContainersState();
}

class _BoxContainersState extends State<BoxContainers>
    with SingleTickerProviderStateMixin {
  List<Widget> children = [];
  AnimationController controller;
  Animation offsetAnimation;
  Offset offset;
  GlobalKey _keyRed = GlobalKey();
  GlobalKey _keyRed2 = GlobalKey();
  Timer timer;
  int count = 0;
  List<int> checkingIndexes = [];
  List<int> gottenIndexes = [];
  StreamController boxesController = new StreamController();
  Color mcolor = Colors.green;

  @override
  void dispose() {
    // TODO: implement dispose
    boxesController.close();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        new AnimationController(vsync: this, duration: Duration(seconds: 3));

    Timer.periodic(Duration(milliseconds: 1000), (Timer t) {
      children.add(new MyHomePage(
        key: Key(children.length.toString()),
        checkOffset: checkOffset,
        index: children.length,
        gotten: gottenIndexes.contains(children.length),
      ));
      boxesController.sink.add(children);
    });
  }

  checkOffset(Offset x, int index, Color color) {
    if (x == null || offset == null || checkingIndexes.contains(index)) return;
    final position1 = x;
    final position2 = offset;
    double s1 = 40;
    double s2 = 40;

    final collide = (position1.dx < position2.dx + s2 &&
        position1.dx + s1 > position2.dx &&
        position1.dy < position2.dy + s2-5 &&
        position1.dy + s1 > position2.dy);
    checkingIndexes.add(index);
    setState(() {});
    if (collide) {
      // print(color.toString());
      mcolor = color;
      gottenIndexes.add(index);
      setState(() {});
      count++;
    } else {
      checkingIndexes.removeWhere((element) => element == index);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double ballTimelyOffset = 1.25;
    return GestureDetector(
      onTapDown: (details) {
        offset = offset ?? _keyRed.globalPaintBounds.topLeft;

        bool right;
        if (details.globalPosition.dx > size.width / 2) {
          right = true;
          // double totalDistance = (size.width*.9-45 - startingOffset.dx) +
          //     ( size.width*.9-45 - size.width*.1) + (startingOffset.dx - size.width*.1);
          // double w1 = (size.width*.9-45 - startingOffset.dx)* 3 /totalDistance ;
          // double w2 = ( size.width*.9-45 - size.width*.1) * 3 /totalDistance ;
          // double w3 = (startingOffset.dx - size.width*.1)*3 /totalDistance ;
          //
          // offsetAnimation = TweenSequence(
          //   [
          //     TweenSequenceItem(
          //         tween: Tween<Offset>(
          //           begin: startingOffset,
          //           end: Offset(size.width*.9-45, size.height*.6),
          //         ),
          //         weight: w1),
          //     TweenSequenceItem(
          //         tween: Tween<Offset>(
          //           begin:Offset(size.width*.9-45, size.height*.6),
          //           end: Offset(size.width*.1, size.height*.6),
          //         ),
          //         weight: w2),
          //     TweenSequenceItem(
          //         tween: Tween<Offset>(
          //           begin: Offset(size.width*.1, size.height*.6),
          //           end: startingOffset,
          //         ),
          //         weight: w3),
          //   ],
          // ).animate(controller);
          // controller.repeat();

        } else {
          right = false;
        }

        timer?.cancel();
        if (right) {
          timer = Timer.periodic(Duration(milliseconds: 1), (Timer t) {
            if (right) {
              if (offset.dx < size.width * .9 - 45) {
                offset = Offset(offset.dx + ballTimelyOffset, offset.dy);
              } else {
                right = false;
                offset = Offset(offset.dx - ballTimelyOffset, offset.dy);
              }
            } else {
              if (offset.dx > size.width * .1) {
                offset = Offset(offset.dx - ballTimelyOffset, offset.dy);
              } else {
                right = true;
                offset = Offset(offset.dx + ballTimelyOffset, offset.dy);
              }
            }
            setState(() {});
          });
        } else {
          timer = Timer.periodic(Duration(milliseconds: 1), (Timer t) {
            if (!right) {
              if (offset.dx > size.width * .1) {
                offset = Offset(offset.dx - ballTimelyOffset, offset.dy);
              } else {
                right = true;
                offset = Offset(offset.dx + ballTimelyOffset, offset.dy);
              }
            } else {
              if (offset.dx < size.width * .9 - 45) {
                offset = Offset(offset.dx + ballTimelyOffset, offset.dy);
              } else {
                right = false;
                offset = Offset(offset.dx - ballTimelyOffset, offset.dy);
              }
            }
            setState(() {});
          });
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            StreamBuilder(
              stream: boxesController.stream,
              builder: (_, snap) {
                List<Widget> newlist = [];
                if (snap.hasData) {
                  // print((snap.data as List)
                  //     .where((element) =>
                  //         gottenIndexes.contains(snap.data.indexOf(element)))
                  //     .map((e) => snap.data.indexOf(e))
                  //     .toList()
                  //     .asMap());
                  newlist =  (snap.data as List)
                      .where((element) =>
                      !gottenIndexes.contains(snap.data.indexOf(element))).toList();
                }
                return Stack(
                  //key: Key('childre ${snap.data?.length??-1}'),

                  children: newlist,
                );
              },
            ),
            Container(
              padding: EdgeInsets.only(
                  top: size.height * .6,
                  left: size.width * .10,
                  right: size.width * .10),
              child: Container(
                key: _keyRed2,
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.2),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            Transform.translate(
              offset:
                  offset ?? Offset(size.width / 2 - (45 / 2), size.height * .6),
              child: Container(
                key: _keyRed,
                height: 45,
                width: 45,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: mcolor),
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum xAxisDirection { postive, negative }

class MyHomePage extends StatefulWidget {
  final Function(Offset x, int index, Color color) checkOffset;
  int index;
  bool gotten;

  MyHomePage({Key key, this.checkOffset, this.index, this.gotten})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Offset offset;
  xAxisDirection direction;
  AnimationController controller, controller2;
  Animation offsetAnimation;
  Animation rotationAnimation;
  Size size;
  Color color;

  setInitialOffset() {
    List colors = [
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.cyan,
      Colors.black,
      Colors.blue
    ];
    color = colors[Random().nextInt(colors.length - 1)];
    size = ScreenUtil.defaultSize;
    double xAxis =
        -100 + Random().nextInt(size.width.round() + 100).ceilToDouble();
    double yAxis = Random().nextInt((size.height * .1).round()).ceilToDouble();
    // print(xAxis);
    // print(yAxis);
    // print(size.width);
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
      widget.checkOffset(offsetAnimation.value, widget.index, color);
    });
    controller.forward();

    controller2.forward();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.gotten);
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
              // print(widget.gotten);
              return Transform.translate(
                offset: offsetAnimation.value,
                child: Transform.rotate(
                  angle: rotationAnimation.value,
                  child: Container(
                    height: 40,
                    width: 40,
                    color: widget.gotten ? Colors.transparent : color,
                  ),
                ),
              );
            }),
      ],
    );
  }
}

extension GlobalKeyEx on GlobalKey {
  Rect get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null)?.getTranslation();
    if (translation != null && renderObject.paintBounds != null) {
      return renderObject.paintBounds
          .shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }
}
