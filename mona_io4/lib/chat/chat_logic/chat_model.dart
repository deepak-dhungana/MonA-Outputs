import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference;

// User classification based on the tasks they can perform in MonA chat
enum UserType { createdRoom, joinedRoom }

class ChatUser {
  // Name of the user
  final String userName;

  // ID of the user [generated during anonymous login in FireBase]
  final String userID;

  UserType userType;

  ChatUser({
    required this.userName,
    required this.userID,
    required this.userType,
  });

  @override
  String toString() {
    return "User Name: $userName\nUser Type: $userType";
  }

  void updateUserType(UserType userType) {
    this.userType = userType;
  }
}

class ChatRoom {
  // Name of the room given by the creator
  final String roomName;

  // Reference to the chat document in FireBase FireStore
  final DocumentReference chatDocumentReference;

  // userID of the person who created this chat room
  final String createdBy;

  // room ID for the users
  final String roomIDForUsers;

  ChatRoom({
    required this.roomName,
    required this.chatDocumentReference,
    required this.createdBy,
    required this.roomIDForUsers,
  });

  @override
  String toString() {
    return "Room Name: $roomName\n"
        "Created By: $createdBy\n"
        "Room ID for users: $roomIDForUsers";
  }
}

class Message {
  final String senderID;
  final String senderName;
  final String message;
  final DateTime time;

  Message(dynamic message)
      : senderID = message["senderID"],
        senderName = message["senderName"],
        message = message["text"],
        time = DateTime.fromMillisecondsSinceEpoch(message["time"] as int);

  bool sameUserSentPrevMessage({required String prevMessageSenderID}) {
    if (prevMessageSenderID == senderID) {
      return true;
    }
    return false;
  }
}
