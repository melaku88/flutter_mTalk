// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:m_talk/models/message_model.dart';
import 'package:m_talk/models/user_model.dart';

class APIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  // for accessing firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  // to return current user
  static User get currentUser => auth.currentUser!;
  // declaring user
  static late UserModel me;

  // get self information
  static Future<void> getSelfInfo()async{
    await firestore.collection('Users').doc(currentUser.uid).get().then((userr) async{
      if(userr.exists){
        me = UserModel.fromJson(userr.data()!);
      }else{
        return;
      }
    });
  }
  // get all users
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllContacts(){
    return firestore.collection('Users').where('id', isNotEqualTo: currentUser.uid).snapshots();
  }


  //***************************************************************** *//

  static String getConversationId(String id){
    List<String> roomId = [currentUser.uid, id];
    roomId.sort();
    return roomId.join('_');
  }

  // get all messages
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(UserModel user){
    return firestore
      .collection('Chats/${getConversationId(user.id)}/message')
      .snapshots();
  }

  // send message
  static Future<void> sendMessage(UserModel user, String message)async{
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final MessageModel messageData = MessageModel(
      fromId: currentUser.uid, 
      toId: user.id, 
      message: message, 
      type: Type.text, 
      sent: time, 
      read: '');
    await firestore
    .collection('Chats/${getConversationId(user.id)}/message')
    .doc(time)
    .set(messageData.toJson());

  }

  // update read message status
  static Future<void> updateReadStatus(MessageModel mssg)async{
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    await firestore.collection('Chats/${getConversationId(mssg.fromId)}/message').doc(mssg.sent).update({'read':time});
  }

  // get last message
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(UserModel user){
    return firestore.collection('Chats/${getConversationId(user.id)}/message').orderBy('sent').limit(1).snapshots();
  }

}
