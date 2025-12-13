import 'package:chatterbox/model/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04,vertical: 4),
      elevation: 0.5,
      color: Colors.blue.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {}, 
        child: ListTile(
          leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
          title: Text(widget.user.name ?? 'Unknown'),
          subtitle: Text(widget.user.about ?? 'null', maxLines: 1,),
          trailing: Text('12:00 PM', style: TextStyle(color: Colors.black54),),
        ),
      )
    );
  }
}