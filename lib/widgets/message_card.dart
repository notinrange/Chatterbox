import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatterbox/api/apis.dart';
import 'package:chatterbox/helpers/my_date_util.dart';
import 'package:chatterbox/main.dart';
import 'package:chatterbox/model/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Apis.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  Widget _blueMessage() {
    if (widget.message.read.isNotEmpty) {
      Apis.updateMessageReadStatus(widget.message);
      log("Message is updated");
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? mq.width * 0.03 : mq.width * 0.04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 211, 245, 255),
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * 0.03),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) =>
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(strokeWidth: 2,),
                          ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: mq.width * 0.04),
            if (widget.message.read.isNotEmpty)
              const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),
            SizedBox(width: 2),
            Padding(
              padding: EdgeInsets.only(left: mq.width * .04),
              child: Text(
                MyDateUtil.getFormattedTime(
                    context: context, time: widget.message.sent),
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? mq.width * 0.03 : mq.width * 0.04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.lightGreen),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * 0.03),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) =>
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(strokeWidth: 2,),
                          ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
