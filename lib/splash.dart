import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roll_rush/colors.dart';
import 'package:roll_rush/dashboard.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 1000), () =>
        Navigator.push(
            context, CupertinoPageRoute(builder: (_) => Dashboard())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logo2.PNG',
          color: primary,
          height: 150,
        ),
      ),
    );
  }
}
