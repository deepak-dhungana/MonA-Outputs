part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

// ############################################################################

class ChatInitial extends ChatState {
  const ChatInitial();

  @override
  String toString() {
    return "Chat BLoC - State: ChatInitial";
  }
}

class ChatInitialAnimated extends ChatState {
  const ChatInitialAnimated();

  @override
  String toString() {
    return "Chat BLoC - State: ChatInitialAnimated";
  }
}

// ############################################################################

class CreateRoomState extends ChatState {
  const CreateRoomState();

  @override
  String toString() {
    return "Chat BLoC - State: CreateRoomState";
  }
}

class JoinRoomState extends ChatState {
  const JoinRoomState();

  @override
  String toString() {
    return "Chat BLoC - State: JoinRoomState";
  }
}

// ############################################################################

class ChatRoomState extends ChatState {

  final ChatUser chatUser;
  final ChatRoom chatRoom;


  const ChatRoomState({required this.chatUser, required this.chatRoom});

  @override
  String toString() {
    return "Chat BLoC - State: ChatRoomState";
  }
}