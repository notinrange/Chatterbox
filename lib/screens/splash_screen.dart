import "package:chatterbox/main.dart";
import "package:chatterbox/screens/home_screen.dart";
import "package:flutter/material.dart";

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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const HomeScreen()));
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
