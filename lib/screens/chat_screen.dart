import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatterbox/api/apis.dart';
import 'package:chatterbox/helpers/my_date_util.dart';
import 'package:chatterbox/main.dart';
import 'package:chatterbox/model/chat_user.dart';
import 'package:chatterbox/model/message.dart';
import 'package:chatterbox/screens/view_profile_screen.dart';
import 'package:chatterbox/widgets/message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];

  final _textController = TextEditingController();

  bool _showEmoji = false;
  bool _isUploading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: PopScope(
          canPop: !_showEmoji,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (_showEmoji) {
              setState(() {
                _showEmoji = false;
              });
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            backgroundColor: const Color.fromARGB(255, 234, 248, 255),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: Apis.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          //   _list.clear();
                          // _list.add(Message(
                          //   fromId: Apis.user.uid,
                          //   toId: 'zyx',
                          //   read: '',
                          //   type: Type.text,
                          //   sent: '12:00 AM',
                          //   msg: 'Hii',
                          //   ));

                          //   _list.add(Message(
                          //   fromId: 'zyx',
                          //   toId: Apis.user.uid,
                          //   read: '',
                          //   type: Type.text,
                          //   sent: '12:05 AM',
                          //   msg: 'Hello',
                          //   ));

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                itemCount: _list.length,
                                padding: EdgeInsets.only(top: mq.height * 0.01),
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(
                                    message: _list[index],
                                  );
                                });
                          } else {
                            return const Center(
                                child: Text('Say Hi! 👋',
                                    style: TextStyle(fontSize: 20)));
                          }
                      }
                    },
                  ),
                ),
                if (_isUploading)
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )),
                _chatInput(),
                if (_showEmoji)
                  EmojiPicker(
                    textEditingController:
                        _textController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                    config: Config(
                      height: 256,
                      checkPlatformCompatibility: true,
                      emojiViewConfig: EmojiViewConfig(
                        columns: 8,
                        backgroundColor:
                            const Color.fromARGB(255, 234, 248, 255),
                        emojiSizeMax: 28 * (Platform.isIOS ? 1.20 : 1.0),
                      ),
                      viewOrderConfig: const ViewOrderConfig(
                        top: EmojiPickerItem.searchBar,
                        middle: EmojiPickerItem.categoryBar,
                        bottom: EmojiPickerItem.emojiView,
                      ),
                      skinToneConfig: const SkinToneConfig(),
                      categoryViewConfig: const CategoryViewConfig(),
                      bottomActionBarConfig: const BottomActionBarConfig(),
                      searchViewConfig: const SearchViewConfig(),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => ViewProfileScreen(user: widget.user)
          ));
        },
        child: StreamBuilder(
            stream: Apis.getUserInfo(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
              return Row(children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black54,
                    )),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * 0.03),
                  child: CachedNetworkImage(
                    width: mq.height * 0.055,
                    height: mq.height * 0.055,
                    imageUrl:
                        list.isNotEmpty ? list[0].image! : widget.user.image!,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(list.isNotEmpty ? list[0].name! : widget.user.name!,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text(
                        list.isNotEmpty
                            ? list[0].isOnline!
                                ? 'Online'
                                : MyDateUtil.getLastActiveTime(
                                    context: context, lastActive: list[0].lastActive!)
                            : MyDateUtil.getLastActiveTime(
                                context: context,
                                lastActive: widget.user.lastActive!),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        )),
                  ],
                )
              ]);
            }));
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Row(children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        _showEmoji = !_showEmoji;
                      });
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                      size: 25,
                    )),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Type Something...',
                      hintStyle: TextStyle(color: Colors.blueAccent),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);
                      for (var image in images) {
                        log('Image Path: ${image.path}');
                        setState(() {
                          _isUploading = true;
                        });
                        await Apis.sendChatImage(widget.user, File(image.path));
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                      size: 26,
                    )),
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        log('Image Path: ${image.path}');
                        setState(() => _isUploading = true);
                        await Apis.sendChatImage(widget.user, File(image.path));
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blueAccent,
                      size: 26,
                    )),
                SizedBox(
                  width: mq.width * .02,
                )
              ]),
            ),
          ),
          MaterialButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  Apis.sendMessage(
                      widget.user, _textController.text, Type.text);
                  _textController.text = '';
                }
              },
              minWidth: 0,
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, right: 5, left: 10),
              shape: CircleBorder(),
              splashColor: Colors.blueGrey,
              color: Colors.black87,
              child: Icon(Icons.send, color: Colors.white, size: 20)),
        ],
      ),
    );
  }
}
