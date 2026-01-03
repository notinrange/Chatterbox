
import "package:cached_network_image/cached_network_image.dart";
import "package:chatterbox/helpers/my_date_util.dart";
import "package:chatterbox/main.dart";
import "package:chatterbox/model/chat_user.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";


class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.user.name!),
        ),


        floatingActionButton: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Joined On ',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16
                      ),
                    ),
                    Text(
                      MyDateUtil.getLastMessageTime(context: context, time: widget.user.createdAt!,showYear: true),
                      style: const TextStyle(color: Colors.black87, fontSize: 16),
                    ),
                  ],
                ),

        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(width: mq.width, height: mq.height * .03),
                  Stack(
                    children: [
                      ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * 0.1),
                              child: CachedNetworkImage(
                                width: mq.height * 0.2,
                                height: mq.height * 0.2,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image ??
                                    "https://media2.dev.to/dynamic/image/width=1000,height=420,fit=cover,gravity=auto,format=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fbrfj77msig1j3b39vshj.png",
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                        child: Icon(CupertinoIcons.person)),
                              ),
                            ),
                    ]
                  ),
                SizedBox(height: mq.height * .03),
                Text(
                  widget.user.email ?? "",
                  style: const TextStyle(color: Colors.black87, fontSize: 16),
                ), 
                SizedBox(height: mq.height * .02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('About ',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16
                      ),
                    ),
                    Text(
                      widget.user.about ?? "",
                      style: const TextStyle(color: Colors.black87, fontSize: 16),
                    ),
                  ],
                ),  
              ],
            ),
          ),
        ),
      ),
    );
  }
}
