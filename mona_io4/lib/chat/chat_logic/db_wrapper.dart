import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_model.dart';

class FirebaseDBWrapper {
  // to prevent instantiation
  FirebaseDBWrapper._();

  // Collection of all chat groups
  static final CollectionReference chats =
      FirebaseFirestore.instance.collection("CHATS");

  static Future<ChatUser> signInAnonymously(
      {required String userName, required UserType userType}) async {
    //sign in user anonymously
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();

    final User? user = userCredential.user;

    if (user == null) {
      throw DBWrapperException(message: "Error initializing user.");
    }

    return ChatUser(
        userName: userName,
        userID: userCredential.user!.uid,
        userType: userType);
  }

  static Future<void> signOut() async {
    //sign out the user
    await FirebaseAuth.instance.signOut();
  }

  static Future<ChatRoom?> createRoom(
      {required String roomName, required String userID}) async {
    if (roomName.isEmpty) {
      throw DBWrapperException(message: "Error creating chat room.");
    }

    try {
      // create a room in DB
      DocumentReference documentReference = await chats.add({
        "room_name": roomName,
        "created_by": userID,
        "time_created": DateTime.now(),
        "messages": [],
      });

      final String roomIDForUsers =
          documentReference.id.substring(0, 4).toUpperCase();

      return ChatRoom(
          roomName: roomName,
          chatDocumentReference: documentReference,
          createdBy: userID,
          roomIDForUsers: roomIDForUsers);
    } catch (e) {
      throw DBWrapperException(message: "Error creating chat room.");
    }
  }

  static Future<ChatRoom?> joinRoom({required String roomID}) async {

    if(roomID.isEmpty){
      throw DBWrapperException(message: "Room ID cannot be empty");
    }

    try {
      QuerySnapshot querySnapshot = await chats.get();

      for (QueryDocumentSnapshot dSnapshot in querySnapshot.docs) {
        if (dSnapshot.id.toLowerCase().startsWith(roomID.toLowerCase())) {
          // time of creation in datetime
          final Timestamp creationTime =
              dSnapshot.get("time_created") as Timestamp;

          if (creationTime.toDate().day == DateTime.now().day) {
            return ChatRoom(
              roomName: dSnapshot.get("room_name"),
              chatDocumentReference: dSnapshot.reference,
              createdBy: dSnapshot.get("created_by"),
              roomIDForUsers: roomID.toUpperCase(),
            );
          } else {
            throw DBWrapperException(message: "Error joining chat room.");
          }
        }
      }

      throw DBWrapperException(
          message: "No room found for the given ID or "
              "an unknown error has occurred.");
    } catch (e) {
      throw DBWrapperException(message: "Error joining chat room.");
    }
  }

  static Future<void> deleteRoom({required ChatRoom chatRoom}) async {
    await chatRoom.chatDocumentReference.delete();
  }

  static Future<void> sendMessage(
      {required String message,
      required DocumentReference chatRoomRef,
      required ChatUser user}) async {
    return chatRoomRef.update({
      "messages": FieldValue.arrayUnion([
        {
          "senderID": user.userID,
          "senderName": user.userName,
          "text": message,
          "time": DateTime.now().millisecondsSinceEpoch
        }
      ])
    }).catchError((error) {
      throw DBWrapperException(message: "Error sending message");
    });
  }
}

class DBWrapperException implements Exception {
  final String message;

  DBWrapperException({required this.message});

  @override
  String toString() {
    return message;
  }
}
