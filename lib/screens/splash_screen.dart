import "dart:developer";

import "package:chatterbox/api/apis.dart";
import "package:chatterbox/main.dart";
import "package:chatterbox/screens/auth/login_screen.dart";
import "package:chatterbox/screens/home_screen.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500),(){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white, statusBarColor: Colors.white)
      );
      if(Apis.auth.currentUser != null){
        log('\nUser: ${Apis.auth.currentUser}');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const HomeScreen()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Welcome to ChatterBox"),
      ),
      body: Stack(children: [
        Positioned( 
          top: mq.height * .15, 
          right: mq.width * .25 , 
          width: mq.width * .5,
          child: Image.asset('images/chat.png')),
        Positioned( 
          bottom: mq.height * .15, 
          width: mq.width,
          child: Text("END TO END ENCRYPTED 🛡️", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black87, letterSpacing: .5),)
          ),
        ],),
    );
  }
}
