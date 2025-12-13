import "dart:developer";

import "package:chatterbox/api/apis.dart";
import "package:chatterbox/main.dart";
import "package:chatterbox/model/chat_user.dart";
import "package:chatterbox/widgets/chat_user_card.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  late AnimationController _controller;
  List<ChatUser> list = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: const Text("ChatterBox"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
        ],
      ),
    
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add_comment_rounded)),
      ),

      body: StreamBuilder(
        stream: Apis.firestore.collection('users').snapshots(),    
        builder: (context,snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
                final data = snapshot.data?.docs;
                log('Data: $data');
                // for(var i in data!){
                //   log('Data: ${jsonEncode(i.data())}');
                //   list.add(i.data()['name']);
                // }
                list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                if(!list.isEmpty){
                    return ListView.builder(
                      itemCount: list.length,
                      padding: EdgeInsets.only(top: mq.height * 0.01),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index){
                        return  ChatUserCard(user: list[index]);
                  });
                }else{
                  return Center(child: Text('No Connections Found', style: TextStyle(fontSize: 20)));
                }
                
          }
          
          
        }, 
         
      ),    
    );
  }
}
