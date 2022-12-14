part of 'view.dart';

class ChatCreateScreen extends StatefulWidget {
  final BuildContext parentContext;

  const ChatCreateScreen({Key? key, required this.parentContext})
      : super(key: key);

  @override
  _ChatCreateScreenState createState() => _ChatCreateScreenState();
}

class _ChatCreateScreenState extends State<ChatCreateScreen>
    with TickerProviderStateMixin {
  static const int _allowedUserNameLength = 8;
  static const int _allowedRoomNameLength = 12;

  // App Localizations
  late final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

  // Text editing controllers
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _chatRoomNameController = TextEditingController();

  // State management
  bool _error = false;
  bool _roomCreationRequested = false;
  bool _roomCreated = false;

  ChatUser? _chatUser;
  ChatRoom? _chatRoom;

  // Scaffold messenger key for error SnackBar
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    _userNameController.dispose();
    _chatRoomNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenInformation screenInfo = ScreenInformation.fromMediaQueryData(
      mediaQueryData: MediaQuery.of(context),
    );

    final double cardWidth = min(450, screenInfo.entireScreenSize.width);

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black.withOpacity(0.40),
        body: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              height: 370,
              width: cardWidth,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _buildCardBody(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardBody() {
    if (_error) {
      return const MonAFailureAnimation(
        size: 60.0,
      );
    }

    if (!_roomCreated && !_roomCreationRequested) {
      return _buildRoomCreationInitialBody();
    }

    if (!_roomCreated && _roomCreationRequested) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return const MonASuccessAnimation(
      size: 60.0,
    );
  }

  Widget _buildRoomCreationInitialBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const CircleAvatar(
                backgroundColor: Color(0xFFf4eff8),
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              )),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            appLocalizations.chat_cj_username,
            style: const TextStyle(
              fontFamily: "cera-gr-bold",
            ),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          decoration: const BoxDecoration(
            color: Color(0xfff4eff8),
            borderRadius: BorderRadius.all(
              Radius.circular(6.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              const Icon(Icons.person_outline),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    hintText: appLocalizations.chat_cj_enter_ur_name,
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30.0,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            appLocalizations.chat_create_room_name,
            style: const TextStyle(
              fontFamily: "cera-gr-bold",
            ),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFf4eff8),
            borderRadius: BorderRadius.all(
              Radius.circular(6.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              const Icon(Icons.chat_outlined),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: TextField(
                  controller: _chatRoomNameController,
                  decoration: InputDecoration(
                    hintText: appLocalizations.chat_create_enter_room_name,
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 40.0,
        ),
        ElevatedButton(
          onPressed: _onCreateChatRoomClick,
          child: Text(
            appLocalizations.chat_create_btn,
            style: const TextStyle(
              fontSize: 18.0,
              fontFamily: "cera-gr-bold",
            ),
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
            minimumSize: MaterialStateProperty.all(
              const Size(450.0, 50.0),
            ),
          ),
        ),
      ],
    );
  }

  void _showErrorSnackBar(String errorMessage, {int duration = 1500}) async {
    _scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        backgroundColor: MonAColors.errorColor,
        duration: Duration(milliseconds: duration),
        content: Row(
          children: <Widget>[
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Flexible(
              child: Text(
                errorMessage,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// ########################################################################

  /// Called when the user clicks on create button
  void _onCreateChatRoomClick() async {
    // Step 1: Read user name
    final String userName = _userNameController.text;

    if (userName.isEmpty) {
      _showErrorSnackBar(appLocalizations.chat_cj_username_error1);
      return;
    }

    if (RegExp(r"^\s+$").hasMatch(userName) ||
        userName.length > _allowedUserNameLength) {
      _showErrorSnackBar(appLocalizations.chat_cj_username_error2);
      return;
    }

    // Step 2: Read room name
    final String roomName = _chatRoomNameController.text;

    if (roomName.isEmpty) {
      _showErrorSnackBar(appLocalizations.chat_create_room_name_error1);
      return;
    }

    if (RegExp(r"^\s+$").hasMatch(roomName) ||
        roomName.length > _allowedRoomNameLength) {
      _showErrorSnackBar(appLocalizations.chat_create_room_name_error2);
      return;
    }

    _createChatRoom(
        userName: _userNameController.text,
        roomName: _chatRoomNameController.text);
  }

  /// Creates a chat room
  void _createChatRoom(
      {required String userName, required String roomName}) async {
    try {
      if (mounted) {
        setState(() {
          _roomCreationRequested = true;
        });
      }

      // Step 1: Anonymous login
      _chatUser = await FirebaseDBWrapper.signInAnonymously(
          userName: userName, userType: UserType.createdRoom);

      if (_chatUser == null) {
        throw Exception("Error signing in user.");
      }

      // step 2: room creation

      _chatRoom = await FirebaseDBWrapper.createRoom(
          roomName: roomName, userID: _chatUser!.userID);

      if (_chatRoom == null) {
        throw Exception("Error creating chat room.");
      }

      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pop(context);

        widget.parentContext.read<ChatBloc>().add(
            ChatRoomConfigured(chatUser: _chatUser!, chatRoom: _chatRoom!));
      });

      if (mounted) {
        setState(() {
          _roomCreated = true;
        });
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(appLocalizations.chat_create_error, duration: 2400);

        setState(() {
          _error = true;
        });

        Future.delayed(const Duration(milliseconds: 2400), () {
          _reset();
        });
      }
    }
  }

  /// Resets back to initial
  void _reset() async {
    if (mounted) {
      setState(() {
        _error = false;
        _roomCreationRequested = false;
        _roomCreated = false;

        _chatUser = null;
        _chatRoom = null;
      });
    }
  }
}
