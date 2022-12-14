import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mona/widgets/failure_anim.dart';

import '../../colors.dart';
import '../../nav_service.dart';
import '../chat_bloc/chat_bloc.dart';
import '../chat_logic/chat_model.dart';
import '../chat_logic/db_wrapper.dart';
import '../../widgets/success_anim.dart';
import '../chat_view/chat_screen/message_card.dart';
import '../../responsive_and_adaptive/screen_info.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'initial_screen.dart';

part 'initial_screen_animated.dart';

part 'create_screen.dart';

part 'join_screen.dart';

part 'chat_screen/chat_screen.dart';

class ChatView extends StatelessWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(builder: (builderContext, state) {
      if (state is ChatInitial) return const ChatInitialBody();

      if (state is ChatInitialAnimated) return const ChatInitialAnimatedBody();

      if (state is ChatRoomState) {
        return ChatScreen(
          chatUser: state.chatUser,
          chatRoom: state.chatRoom,
        );
      }

      return Container();
    });
  }
}
