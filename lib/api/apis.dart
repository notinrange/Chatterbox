import 'dart:developer';
import 'dart:io';

import 'package:chatterbox/config/cloudinary_config.dart';
import 'package:chatterbox/model/chat_user.dart';
import 'package:chatterbox/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static final cloudinary = CloudinaryPublic(
    CloudinaryConfig.cloudName,
    CloudinaryConfig.uploadPreset,
    cache: false,
  );


  static late ChatUser me;
  static User get user => auth.currentUser!;
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        log('My Data: ${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        id: user.uid,
        name: user.displayName.toString(),
        email: user.email.toString(),
        about: "Hey, I'm using ChatterBox!",
        image: user.photoURL.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '');
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id!)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(ChatUser chatUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(
        toId: chatUser.id!,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id!)}/messages/');

    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updateMessageReadStatus(Message message)async{
    firestore
    .collection('chats/${getConversationID(message.fromId)}/messages/')
    .doc(message.sent)
    .update({'read':DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(ChatUser user){
    return firestore
        .collection('chats/${getConversationID(user.id!)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }
  
  // static Future<void> updateProfilePicture(File file) async {
  //   //getting image file extension
  //   final ext = file.path.split('.').last;
  //   log('Extension : $ext');

  //   //storage file ref with path
  //   final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

  //   await ref
  //       .putFile(file, SettableMetadata(contentType: 'image/$ext'))
  //       .then((p0) {
  //     log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
  //   });

  //   //updating image in firestore database
  //   me.image = await ref.getDownloadURL();
  //   await firestore
  //       .collection('users')
  //       .doc(user.uid)
  //       .update({'image': me.image});
  // }

  // static Future<void> sendChatImage(ChatUser chatUser, File file) async {
  //   //getting image file extension
  //   final ext = file.path.split('.').last;

  //   //storage file ref with path
  //   final ref = storage.ref().child('images/${getConversationID(chatUser.id!)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

  //   await ref
  //       .putFile(file, SettableMetadata(contentType: 'image/$ext'))
  //       .then((p0) {
  //     log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
  //   });

  //   //updating image in firestore database
  //   final finalURL = await ref.getDownloadURL();
  //   await sendMessage(chatUser, finalURL, Type.image);
  // }

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String,dynamic>>> getUserInfo( ChatUser chatUser){
    return firestore
              .collection('users')
              .where('id',isEqualTo: chatUser.id)
              .snapshots();
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async{
    firestore.collection('users').doc(user.uid).update({
      'is_online' : isOnline,
      'last_active' : DateTime.now().millisecondsSinceEpoch.toString()
    });
  }


  // ============ CLOUDINARY METHODS ============
  
  /// Upload profile picture to Cloudinary
  static Future<void> updateProfilePicture(File file) async {
    try {
      log('Uploading profile picture to Cloudinary...');
      
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          folder: CloudinaryConfig.profilePicturesFolder, // Use from config
          publicId: user.uid,
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      log('Upload successful: ${response.secureUrl}');
      
      // Get optimized URL
      final optimizedUrl = response.secureUrl.replaceFirst(
        '/upload/', 
        '/upload/${CloudinaryConfig.profilePicTransform}/', // Use from config
      );
      
      me.image = optimizedUrl;
      await firestore
          .collection('users')
          .doc(user.uid)
          .update({'image': me.image});
          
    } catch (e) {
      log('Error uploading profile picture: $e');
      rethrow;
    }
  }

  /// Send chat image using Cloudinary
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    try {
      log('Uploading chat image to Cloudinary...');
      
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          folder: '${CloudinaryConfig.chatImagesFolder}/${getConversationID(chatUser.id!)}', // Use from config
          publicId: timestamp.toString(),
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      log('Upload successful: ${response.secureUrl}');
      
      // Get optimized URL
      final optimizedUrl = response.secureUrl.replaceFirst(
        '/upload/', 
        '/upload/${CloudinaryConfig.chatImageTransform}/', // Use from config
      );
      
      await sendMessage(chatUser, optimizedUrl, Type.image);
      
    } catch (e) {
      log('Error uploading chat image: $e');
      rethrow;
    }
  }
}
