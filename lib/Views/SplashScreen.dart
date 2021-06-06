import 'dart:async';

import 'package:familytree/Controllers/SplashScreenController.dart';
import 'package:familytree/Models/Colors.dart';
import 'package:familytree/Models/Strings.dart';
import 'package:familytree/Models/Utils.dart';
import 'package:flutter/material.dart';
import 'package:familytree/Views/Home.dart';
import 'package:familytree/Views/Login.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;

  @override
  void initState() {
    super.initState();
    startApp();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Utils.displaySize = MediaQuery.of(context).size;

    return Container(
      color: UtilColors.primaryColor,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: UtilColors.whiteColor,
        body: Stack(
          children: [
            Align(
              child: Container(
                height: Utils.displaySize.width * 0.3,
                width: Utils.displaySize.width * 0.3,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  void startApp() async {
    await SplashScreenController().checkAuth().then((value) {
      _timer = Timer.periodic(
          Duration(seconds: 3),
          (t) => Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(
                    builder: (_) => (value == true) ? Home() : Login()),
              ));
    });
  }
}
