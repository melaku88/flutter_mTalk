import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:m_talk/screens/home_screen.dart';
import 'package:m_talk/screens/login_screen.dart';

//splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isAnimate = false;

  void controllAnimation() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  void controllNavigation() {
    Future.delayed(const Duration(seconds: 5), () {
      //navigate
      if(FirebaseAuth.instance.currentUser != null){
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }else{
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    });
  }

    @override
  void initState() {
    super.initState();
    controllAnimation();
    controllNavigation();
  }


  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    var mq = MediaQuery.sizeOf(context);

    return Scaffold(
      //body
      body: Stack(children: [
        //app logo
        AnimatedPositioned(
          top: mq.height * .15,
          left: _isAnimate ? mq.width * .2 : mq.width * .1,
          width: mq.width * .3,
          duration: Duration(milliseconds: 2500),
          child: Image.asset('images/splash1.png')),
        AnimatedPositioned(
          top: mq.height * .15,
          right: _isAnimate ? mq.width * .2 : mq.width * .1,
          width: mq.width * .3,
          duration: Duration(milliseconds: 2500),
          child: Image.asset('images/splash2.png')),

        //google login button
        Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: const Text('DEVELOPED IN ETHIOPIA BY M.B WITH ❤️',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15, color: Colors.black87, letterSpacing: .5))),
      ]),
    );
  }
}
