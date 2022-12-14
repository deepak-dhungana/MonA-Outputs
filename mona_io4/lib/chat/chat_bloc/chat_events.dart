part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

// ############################################################################

class GoBack extends ChatEvent {
  const GoBack();

  @override
  String toString() {
    return "Chat BLoC - Event: GoBack";
  }
}

class CreateRoomEvent extends ChatEvent {
  const CreateRoomEvent();

  @override
  String toString() {
    return "Chat BLoC - Event: CreateRoomEvent";
  }
}

class JoinRoomEvent extends ChatEvent {
  const JoinRoomEvent();

  @override
  String toString() {
    return "Chat BLoC - Event: JoinRoomEvent";
  }
}

class ChatRoomConfigured extends ChatEvent {
  final ChatUser chatUser;
  final ChatRoom chatRoom;

  const ChatRoomConfigured({required this.chatUser, required this.chatRoom});

  @override
  String toString() {
    return "Chat BLoC - Event: ChatRoomConfigured";
  }
}
