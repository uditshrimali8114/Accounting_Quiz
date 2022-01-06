import 'dart:async';
import 'package:accounting_quiz/bottombar.dart';
import 'package:accounting_quiz/dashboard.dart';
import 'package:accounting_quiz/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreen> {

  var token;
  Future getData() async{
    var preferences = await SharedPreferences.getInstance();
    var savedValue = preferences.getString('token');
    setState(() {
      token = savedValue;
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
    var Bottom = 0;
    getData();
    Timer(const Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) => token== null ? Login() : bottomBar(bottom: Bottom)

            )
        )
    );

  }
  var size,height,width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;


    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
    image : new DecorationImage(
    image: new ExactAssetImage('assets/Splash/Splash.png'),
    fit: BoxFit.cover,
      ),
    ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            // height: height*0,
          ),
          Container(
            // padding: EdgeInsets.all(100),
              // margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Image.asset('assets/Splash/trainer.png', width:width*0.4,
                  fit:BoxFit.fill)),
          Image.asset('assets/Splash/Image.png', width:width*0.85,
              fit:BoxFit.fill),
        ],
      ),
    );
  }

}
// child: const Image(
// image: AssetImage('assets/Splash/Splash.png'),
// fit: BoxFit.cover,
// height: double.infinity,
// width: double.infinity,
// alignment: Alignment.center,
// ),