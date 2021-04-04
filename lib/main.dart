import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roll_rush/colors.dart';
import 'package:roll_rush/game_area.dart';
import 'package:roll_rush/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) => runApp(ProviderScope(child: MyApp())));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primary,
        accentColor: primary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: dark,
        textTheme: GoogleFonts.concertOneTextTheme(
            // Theme.of(context).textTheme,
            ),
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation offsetAnimation;
  Animation offsetAnimation2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    offsetAnimation = Tween<double>(begin: 0, end: .65).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutCirc));
    offsetAnimation2 = Tween<double>(begin: -0.4, end: 0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutCirc));
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
                      key: Key((offsetAnimation2.value == 0).toString()),
                      screenSize: size,
                      gameInView: offsetAnimation2.value == 0,
                      gameEndAnimation: (){
                        controller.reverse();
                      }
                    )),
                Transform.translate(
                    offset: Offset(0.0, size.height * offsetAnimation.value),
                    child: Home(
                      yOffset: size.height * offsetAnimation.value,
                        gameStartAnimation: (){
                          controller.forward();
                        }
                    ))
              ],
            );
          }),
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
