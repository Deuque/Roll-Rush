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

class _BoxContainersState extends State<BoxContainers> {
  List<Widget> children = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(milliseconds: 700), (Timer t){
      children.add(new MyHomePage(key: Key(children.length.toString()),));
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: children,
      ),
    );
  }
}

enum xAxisDirection { postive, negative }

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin {
  Offset offset;
  xAxisDirection direction;
  AnimationController controller,controller2;
  Animation offsetAnimation;
  Animation rotationAnimation;
  Size size;

  setInitialOffset() {
    size = ScreenUtil.defaultSize;
    double xAxis = -100 + Random().nextInt(size.width.round()+100).ceilToDouble();
    double yAxis = Random().nextInt((size.height * .1).round()).ceilToDouble();
    print(xAxis);
    print(yAxis);
    // print(size.width);
    offset = Offset(xAxis, 0);
    direction =
        xAxis < size.width/2 ? xAxisDirection.postive : xAxisDirection.negative;

    controller =
        new AnimationController(vsync: this, duration: Duration(seconds: 3));
    controller2 =
    new AnimationController(vsync: this, duration: Duration(seconds: 12));
    offsetAnimation = Tween<Offset>(
            begin: offset,
            end: Offset(
                direction == xAxisDirection.postive
                    ? (size.width / 2)
                        + ((size.width / 2) - offset.dx)
                    : (size.width / 2) - (  offset.dx - (size.width / 2)),
                size.height * .7))
        .animate(controller);
    rotationAnimation = Tween<double>(
        begin: 0,
        end:direction == xAxisDirection.postive ?  -2 * pi : 2 * pi)
        .animate(controller2);

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
                    height: 40,
                    width: 40,
                    color: Colors.red,
                  ),
                ),
              );
            }),
      ],
    );
  }
}
