import "package:chatterbox/main.dart";
import "package:chatterbox/screens/home_screen.dart";
import "package:flutter/material.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{

  bool _isAnimated = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500),(){
      setState(() {
        _isAnimated = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Welcome to ChatterBox"),
      ),
      body: Stack(children: [
        AnimatedPositioned( 
          top: mq.height * .15, 
          right: _isAnimated ? mq.width * .25 : -mq.width * .5, 
          width: mq.width * .5,
          duration: const Duration(seconds: 1),
          child: Image.asset('images/chat.png')),
        Positioned( 
          bottom: mq.height * .15, 
          left: mq.width * .05, 
          width: mq.width * .9,
          height: mq.height * .07,
          child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: StadiumBorder(), elevation: 1),
                  onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const HomeScreen()));
                  }, 
                  icon: Image.asset('images/google.png', height: mq.height* .06,),
                  label: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan( text :'Sign in with '), 
                        TextSpan(text:'Google',style:TextStyle(fontWeight: FontWeight.w500)),
                        ])
                      ,),
            )
          ),
        ],),
    );
  }
}
