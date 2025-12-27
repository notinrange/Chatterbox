import 'dart:developer';
import 'dart:io';

import 'package:chatterbox/model/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static late ChatUser me;
  static User get user => auth.currentUser!;
  static Future<bool> userExists() async{
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  static Future<void> getSelfInfo() async{
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if(user.exists){
          me = ChatUser.fromJson(user.data()!);
          log('My Data: ${user.data()}');
      }else{
        await createUser().then((value)=>getSelfInfo());
      }
    });
  }
  static Future<void> createUser() async{
    final time = DateTime.now().millisecondsSinceEpoch.toString();
      final chatUser = ChatUser(
        id : user.uid,
        name : user.displayName.toString(),
        email: user.email.toString(),
        about: "Hey, I'm using ChatterBox!",
        image: user.photoURL.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: ''
      );
    return await firestore.collection('users').doc(user.uid).set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>  getAllUsers(){
    return firestore.collection('users').where('id', isNotEqualTo: user.uid).snapshots();
  }

  static Future<void> updateUserInfo() async{
    await firestore.collection('users').doc(user.uid).update(
      {
        'name':me.name,
        'about':me.about
      });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(){
      return firestore
        .collection('messages')
        .snapshots();
  }

  static Future<void> updateProfilePicture(File file) async{
    //getting image file extension
    final ext = file.path.split('.').last;
    log('Extension : $ext');

    //storage file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'))
            .then((p0){
              log('Data Transferred: ${p0.bytesTransferred/1000} kb');

         });
    
    //updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image':me.image});

    
  }
}