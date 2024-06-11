import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:senraise_printer_example/screens/login_screen.dart';
import 'package:camera/camera.dart';

class Mysplash extends StatefulWidget {
  const Mysplash({super.key});

  @override
  State<Mysplash> createState() => _MysplashState();
}

class _MysplashState extends State<Mysplash> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: const Color(0xff00BFB2),
      splash: Image.asset("images/foxvizwhite.png"), 
      nextScreen: Login());
  }
}
