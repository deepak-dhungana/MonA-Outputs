import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mona/chat/chat_logic/chat_model.dart';

part 'chat_events.dart';

part 'chat_states.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatInitial()) {
    on<GoBack>(_onGoBack);
    on<ChatRoomConfigured>(_onChatRoomConfigured);
  }

  void _onGoBack(GoBack event, Emitter<ChatState> emit) {

    if (state is ChatRoomState) {
      emit(const ChatInitialAnimated());
    }
  }

  void _onChatRoomConfigured(
      ChatRoomConfigured event, Emitter<ChatState> emit) {
    emit(ChatRoomState(chatUser: event.chatUser, chatRoom: event.chatRoom));
  }
}
