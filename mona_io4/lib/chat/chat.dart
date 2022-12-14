import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';
import 'chat_bloc/chat_bloc.dart';
import 'chat_view/view.dart';

class Chat extends StatefulWidget {

  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with AutomaticKeepAliveClientMixin {
  // for managing Firebase initialization states
  bool _initialized = false;
  bool _error = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // start the process of initializing Firebase
    _initializeFirebase();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // check if error has occurred
    if (_error) {
      return const Center(
        child: Text("Error"),
      );
    }

    // check if Firebase has been initialized or not
    if (!_initialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // else return the main chat screen
    return BlocProvider(
      create: (_) => ChatBloc(),
      child: const ChatView(),
    );
  }

  // ##########################################################################

  /// Initializes Firebase and updates the states accordingly.
  void _initializeFirebase() async {
    try {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);

      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = true;
        });
      }
    }
  }

  /// Called if an error has occurred and the user wishes to
  /// retry initializing Firebase again.
  void _retry() async {
    // First, reset the states
    if (mounted) {
      setState(() {
        _initialized = false;
        _error = false;
      });
    }
    // then try to initialize again
    _initializeFirebase();
  }
}
