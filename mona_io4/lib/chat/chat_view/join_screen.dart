part of 'view.dart';

class ChatJoinScreen extends StatefulWidget {
  final BuildContext parentContext;

  const ChatJoinScreen({Key? key, required this.parentContext})
      : super(key: key);

  @override
  _ChatJoinScreenState createState() => _ChatJoinScreenState();
}

class _ChatJoinScreenState extends State<ChatJoinScreen>
    with TickerProviderStateMixin {
  static const int _allowedUserNameLength = 8;

  // App Localizations
  late final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

  // Scaffold messenger key for error SnackBar
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Text editing controller for the username
  final TextEditingController _userNameController = TextEditingController();

  // Text editing controllers for the room ID
  final List<TextEditingController> _roomIDControllers =
      List.generate(4, (_) => TextEditingController(), growable: false);

  // Focus nodes for room ID
  final List<FocusNode> _roomIDNodes = List.generate(4, (_) => FocusNode());

  // Card elevation for room ID input field cards
  final List<double> _roomIDCardElevations = List.generate(4, (_) => 0.0);

  // Card border color for room ID input field cards
  final List<Color> _roomIDCardBorderColor =
      List.generate(4, (_) => Colors.transparent);

  static const double _focusedCardElevation = 8.0;
  static const double _unfocusedCardElevation = 0.0;

  static const Color _focusedRoomIDCardColor = Color(0xFF491D68);
  static const Color _unfocusedRoomIDCardColor = Colors.transparent;

  // State management
  bool _error = false;
  bool _roomJoiningRequested = false;
  bool _roomJoined = false;

  ChatUser? _chatUser;
  ChatRoom? _chatRoom;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < _roomIDNodes.length; i++) {
      _roomIDNodes[i].addListener(() {
        if (_roomIDNodes[i].hasFocus) {
          if (mounted) {
            setState(() {
              _roomIDCardElevations[i] = _focusedCardElevation;
              _roomIDCardBorderColor[i] = _focusedRoomIDCardColor;

              // on focus change everything on the text field is selected
              _roomIDControllers[i].selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _roomIDControllers[i].text.length);
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _roomIDCardElevations[i] = _unfocusedCardElevation;
              _roomIDCardBorderColor[i] = _unfocusedRoomIDCardColor;
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    // disposing username and room ID controllers + focus nodes
    _userNameController.dispose();

    for (TextEditingController controller in _roomIDControllers) {
      controller.dispose();
    }

    for (FocusNode focusNode in _roomIDNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black.withOpacity(0.40),
        body: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              height: 370,
              width: 450,
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
      return const MonAFailureAnimation(size: 60.0);
    }

    if (!_roomJoined && !_roomJoiningRequested) {
      return _buildRoomJoiningInitialBody();
    }

    if (!_roomJoined && _roomJoiningRequested) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return const MonASuccessAnimation(
      size: 60.0,
    );
  }

  Widget _buildRoomJoiningInitialBody() {
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
            color: Color(0xFFf4eff8),
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
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                  ),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (text) {
                    _roomIDNodes[0].requestFocus();
                  },
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
            appLocalizations.chat_join_room_id,
            style: const TextStyle(
              fontFamily: "cera-gr-bold",
            ),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        LayoutBuilder(
          builder: (lbContext, lbConstraints) {

            // 32 is the default margin of 4 cards. [4 * 8 = 32]
            final double availableWidth = lbConstraints.maxWidth - 32;

            final double cardSize = min(60, availableWidth / 4);

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildRoomIDField(index: 0, cardSize: cardSize),
                _buildRoomIDField(index: 1, cardSize: cardSize),
                _buildRoomIDField(index: 2, cardSize: cardSize),
                _buildRoomIDField(index: 3, cardSize: cardSize),
              ],
            );
          },
        ),
        const SizedBox(
          height: 30.0,
        ),
        ElevatedButton(
          onPressed: _onJoinChatRoomClick,
          child: Text(
            appLocalizations.chat_join_btn,
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

  /// Room ID widgets
  Widget _buildRoomIDField({required int index, required double cardSize}) {
    return Card(
      color: const Color(0xFFede7fa),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 2,
          color: _roomIDCardBorderColor[index],
        ),
        borderRadius: BorderRadius.circular(6.0),
      ),
      elevation: _roomIDCardElevations[index],
      child: SizedBox(
        width: cardSize,
        height: cardSize,
        child: Theme(
          data: ThemeData(
            textSelectionTheme: const TextSelectionThemeData(
              selectionColor: Colors.transparent,
            ),
          ),
          child: TextField(
            focusNode: _roomIDNodes[index],
            controller: _roomIDControllers[index],
            inputFormatters: [
              UpperCaseTextFormatter(),
            ],
            onChanged: (userInput) {
              if (userInput.length == 1 && index < 3) {
                _roomIDNodes[index + 1].requestFocus();
              }
            },
            style:
                TextStyle(fontFamily: "cera-gr-bold", fontSize: cardSize / 2),
            decoration: const InputDecoration(
                border: InputBorder.none, counterText: ""),
            showCursor: false,
            maxLines: 1,
            maxLength: 1,
            textAlign: TextAlign.center,
            enableSuggestions: false,
            textInputAction:
                index == 3 ? TextInputAction.done : TextInputAction.next,
          ),
        ),
      ),
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

// ##########################################################################

  /// Called when the user clicks on create button
  void _onJoinChatRoomClick() async {
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

    // Step 2: Read room id
    final String roomID = await _getRoomID();

    if (RegExp(r"^\s+$").hasMatch(roomID) || roomID.length != 4) {
      _showErrorSnackBar(appLocalizations.chat_join_error1);
      return;
    }

    _joinChatRoom(userName: userName, roomID: roomID);
  }

  /// Joins a chat room
  void _joinChatRoom({required String userName, required String roomID}) async {
    if (mounted) {
      setState(() {
        _roomJoiningRequested = true;
      });
    }

    try {
      // Step 1: Anonymous login
      _chatUser = await FirebaseDBWrapper.signInAnonymously(
          userName: userName, userType: UserType.joinedRoom);

      if (_chatUser == null) {
        throw Exception("Error signing in user.");
      }

      // step 2: room joining

      _chatRoom = await FirebaseDBWrapper.joinRoom(roomID: roomID);

      if (_chatRoom == null) {
        throw Exception("Error creating chat room.");
      }

      if (_chatRoom!.createdBy == _chatUser!.userID) {
        _chatUser!.updateUserType(UserType.createdRoom);
      }

      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pop(context);

        widget.parentContext.read<ChatBloc>().add(
            ChatRoomConfigured(chatUser: _chatUser!, chatRoom: _chatRoom!));
      });

      if (mounted) {
        setState(() {
          _roomJoined = true;
        });
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(appLocalizations.chat_join_error3, duration: 2400);

        setState(() {
          _error = true;
        });

        Future.delayed(const Duration(milliseconds: 2400), () {
          _reset();
        });
      }
    }
  }

  /// Reads Room ID input from the 4 fields
  Future<String> _getRoomID() async {
    String roomID = "";

    for (TextEditingController controller in _roomIDControllers) {
      roomID += controller.text;
    }
    return roomID;
  }

  /// Resets back to initial
  void _reset() async {
    if (mounted) {
      setState(() {
        _error = false;
        _roomJoiningRequested = false;
        _roomJoined = false;

        _chatUser = null;
        _chatRoom = null;
      });
    }
  }
}

// ############################################################################

/// Text input formatter for room ID
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
