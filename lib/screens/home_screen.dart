import "dart:developer";

import "package:chatterbox/api/apis.dart";
import "package:chatterbox/main.dart";
import "package:chatterbox/model/chat_user.dart";
import "package:chatterbox/screens/profile_screen.dart";
import "package:chatterbox/widgets/chat_user_card.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    Apis.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: !_isSearching,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (_isSearching) {
            setState(() {
              _isSearching = false;
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(CupertinoIcons.home),
            title: _isSearching ? TextField(
              decoration: InputDecoration(border: InputBorder.none, hintText: 'enter name or email'),
              autofocus: true,
              style: TextStyle(fontSize: 16, letterSpacing: 0.5,),
              onChanged: (val){
                _searchList.clear();
                for (var i in _list) {
                  if ((i.name?.toLowerCase() ?? '').contains(val.toLowerCase()) ||
                      (i.email?.toLowerCase() ?? '').contains(val.toLowerCase())) {
                    _searchList.add(i);
                  }
                }
                setState(() {
                  _searchList;
                });
              },
            ) :  Text("ChatterBox"),
            actions: [
              IconButton(onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              }, icon: const Icon(Icons.search)),
              IconButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfileScreen(user: Apis.me,)));
              }, icon: Icon(Icons.more_vert))
            ],
          ),
        
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add_comment_rounded)),
          ),
        
          body: StreamBuilder(
            stream: Apis.getAllUsers(),    
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
                    //   _list.add(i.data()['name']);
                    // }
                    _list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                    if(!_list.isEmpty){
                        return ListView.builder(
                          itemCount: _isSearching ? _searchList.length : _list.length,
                          padding: EdgeInsets.only(top: mq.height * 0.01),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index){
                            return  ChatUserCard(user: _isSearching ? _searchList[index] : _list[index]);
                      });
                    }else{
                      return Center(child: Text('No Connections Found', style: TextStyle(fontSize: 20)));
                    }
                    
              }
              
              
            }, 
             
          ),    
        ),
      ),
    );
  }
}
