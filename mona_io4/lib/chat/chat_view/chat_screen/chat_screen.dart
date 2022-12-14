part of '../view.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser chatUser;
  final ChatRoom chatRoom;

  const ChatScreen({Key? key, required this.chatUser, required this.chatRoom})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _chatController = TextEditingController();

  final ScrollController _listViewScrollController = ScrollController();

  String _roomIDForUsers = "";
  String _roomName = "";

  // animation stuff
  late AnimationController _animController;
  late Animation<Offset> _animation;

  // Main screen bottom padding
  // required for measuring the padding of the chat send-box
  late final double _mainScreenBottomPadding;

  @override
  void initState() {
    super.initState();

    _mainScreenBottomPadding =
        MediaQuery.of(NavigationService.mainKey.currentContext!).padding.bottom;

    _animController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
    _animation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.fastLinearToSlowEaseIn,
    ));

    _roomName = widget.chatRoom.roomName;
    _roomIDForUsers = widget.chatRoom.roomIDForUsers;
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _removeFocus() {
    final FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScreenInformation screenInfo = ScreenInformation.fromMediaQueryData(
        mediaQueryData: MediaQuery.of(context));

    return SlideTransition(
      position: _animation,
      child: _buildBodyByScreenType(screenInfo),
    );
  }

  Widget _buildBodyByScreenType(ScreenInformation screenInfo) {
    switch (screenInfo.screenType) {
      case ScreenType.mobilePortrait:
        return _buildMobilePortraitBody(screenInfo);

      case ScreenType.mobileLandscape:
        return _buildMobileLandscapeBody(screenInfo);

      case ScreenType.tabletPortrait:
        return _buildTabletPortraitBody(screenInfo);

      case ScreenType.tabletLandscape:
        return _buildTabletLandscapeBody(screenInfo);
    }
  }

  Widget _buildMobilePortraitBody(ScreenInformation screenInfo) {
    final Size screenSize = screenInfo.entireScreenSize;

    // kBottomNavigationBarHeight - 10 = 46
    double bottomPadding =
        screenInfo.bottomViewInsets - 46 - _mainScreenBottomPadding;
    bottomPadding = bottomPadding > 0 ? bottomPadding : 10;

    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        _removeFocus();
      },
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.20,
            child: Image.asset(
              "assets/chat_background/mobile_portrait.png",
              width: screenSize.width,
              height: screenSize.height,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Material(
                elevation: 10.0,
                child: Container(
                  padding: EdgeInsets.only(
                    top: screenInfo.topPadding,
                    left: screenSize.width * 0.02,
                    right: screenSize.width * 0.02,
                  ),
                  height: screenInfo.topPadding + screenSize.height * 0.10,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xFF05836c),
                        Color(0xFF03735d),
                        Color(0xFF00634f),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: _zoomInRoomID,
                        icon: const Icon(
                          Icons.zoom_in_rounded,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: screenSize.width * 0.05,
                      ),
                      Expanded(
                        child:
                            LayoutBuilder(builder: (lbContext, lbConstraints) {
                          final double availableHeight =
                              lbConstraints.maxHeight;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "ID:$_roomIDForUsers",
                                style: TextStyle(
                                  fontSize: availableHeight * 0.33,
                                  fontFamily: "roboto-mono-medium",
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: availableHeight * 0.025,
                              ),
                              Text(
                                _roomName,
                                style: TextStyle(
                                    fontSize: availableHeight * 0.20,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        }),
                      ),
                      SizedBox(
                        width: screenSize.width * 0.05,
                      ),
                      _getLeaveIcon(),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 1,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: widget.chatRoom.chatDocumentReference.snapshots(),
                  builder:
                      (BuildContext chatBodyContext, AsyncSnapshot snapshot) {
                    //if error happened retrieving the chat snapshot
                    if (snapshot.hasError) {
                      return const MonAFailureAnimation(
                        size: 20,
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }

                    final List<dynamic> messages;

                    try {
                      messages = snapshot.data.data()["messages"];
                    } catch (e) {
                      if (widget.chatUser.userType == UserType.joinedRoom) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Card(
                              color: MonAColors.darkWarmRed,
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 15.0),
                                child: SizedBox(
                                  width: screenSize.width - 40,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        appLocalizations
                                            .chat_deleted_by_creator,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: "cera-gr-medium",
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 25.0,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<ChatBloc>()
                                              .add(const GoBack());
                                        },
                                        child: Text(
                                          appLocalizations.leave,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: "cera-gr-bold",
                                            color: Colors.black,
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      // return nothing if the user is the creator
                      return Container();
                    }
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      controller: _listViewScrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 10.0),
                      itemBuilder: ((liViewContext, index) {
                        index = messages.length - (index + 1);

                        final Message message = Message(messages[index]);

                        final bool sentByMe =
                            message.senderID == widget.chatUser.userID;

                        final bool sameUserSentPrevMsg =
                            message.sameUserSentPrevMessage(
                                prevMessageSenderID: index > 0
                                    ? messages[index - 1]["senderID"]
                                    : "");

                        if (sentByMe) {
                          if (sameUserSentPrevMsg) {
                            return MessageCardType1(message: message);
                          } else {
                            return MessageCardType1(
                              message: message,
                              extraTopPadding: true,
                            );
                          }
                        } else {
                          if (sameUserSentPrevMsg) {
                            return MessageCardType3(message: message);
                          } else {
                            return MessageCardType2(message: message);
                          }
                        }
                      }),
                    );
                  },
                ),
              ),
              const Divider(
                height: 1,
              ),
              Material(
                elevation: 10,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: screenSize.width * 0.05,
                      right: screenSize.width * 0.05,
                      top: 10.0,
                      bottom: bottomPadding,
                    ),
                    color: monaMaterialMagenta.shade50.withOpacity(0.50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            child: TextField(
                              controller: _chatController,
                              autofocus: false,
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: "Message...",
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                  vertical: 15.0,
                                ),
                              ),
                              minLines: 1,
                              maxLines: 4,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: CircleAvatar(
                            child: Center(
                              child: IconButton(
                                  onPressed: () {
                                    _sendMessage();
                                  },
                                  icon: const Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLandscapeBody(ScreenInformation screenInfo) {
    final Size screenSize = screenInfo.entireScreenSize;

    double bottomPadding =
        screenInfo.bottomViewInsets + screenInfo.bottomPadding + 10;

    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        _removeFocus();
      },
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.20,
            child: Image.asset(
              "assets/chat_background/mobile_landscape.png",
              width: screenSize.width,
              height: screenSize.height,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Material(
                elevation: 10.0,
                child: Container(
                  padding: EdgeInsets.only(
                    top: screenInfo.topPadding,
                    left: 10,
                    right: screenInfo.rightPadding + 10,
                  ),
                  height: screenInfo.topPadding + screenSize.height * 0.125,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xFF05836c),
                        Color(0xFF03735d),
                        Color(0xFF00634f),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: _zoomInRoomID,
                        icon: const Icon(
                          Icons.zoom_in_rounded,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: screenSize.width * 0.05,
                      ),
                      Expanded(
                        child:
                            LayoutBuilder(builder: (lbContext, lbConstraints) {
                          final double availableHeight =
                              lbConstraints.maxHeight;

                          return Text(
                            _roomName,
                            style: TextStyle(
                                fontSize: availableHeight * 0.40,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          );
                        }),
                      ),
                      SizedBox(
                        width: screenSize.width * 0.05,
                      ),
                      _getLeaveIcon(),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 1,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: widget.chatRoom.chatDocumentReference.snapshots(),
                  builder:
                      (BuildContext chatBodyContext, AsyncSnapshot snapshot) {
                    //if error happened retrieving the chat snapshot
                    if (snapshot.hasError) {
                      return const MonAFailureAnimation(
                        size: 20,
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }

                    final List<dynamic> messages;

                    try {
                      messages = snapshot.data.data()["messages"];
                    } catch (e) {
                      if (widget.chatUser.userType == UserType.joinedRoom) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Card(
                              color: MonAColors.darkWarmRed,
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 15.0),
                                child: SizedBox(
                                  width: screenSize.width - 40,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        appLocalizations
                                            .chat_deleted_by_creator,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: "cera-gr-medium",
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 25.0,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<ChatBloc>()
                                              .add(const GoBack());
                                        },
                                        child: Text(
                                          appLocalizations.leave,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: "cera-gr-bold",
                                            color: Colors.black,
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      // return nothing if the user is the creator
                      return Container();
                    }

                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      controller: _listViewScrollController,
                      padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 5,
                          right: screenInfo.rightPadding + 5),
                      itemBuilder: ((liViewContext, index) {
                        index = messages.length - (index + 1);

                        final Message message = Message(messages[index]);

                        final bool sentByMe =
                            message.senderID == widget.chatUser.userID;

                        final bool sameUserSentPrevMsg =
                            message.sameUserSentPrevMessage(
                                prevMessageSenderID: index > 0
                                    ? messages[index - 1]["senderID"]
                                    : "");

                        if (sentByMe) {
                          if (sameUserSentPrevMsg) {
                            return MessageCardType1(message: message);
                          } else {
                            return MessageCardType1(
                              message: message,
                              extraTopPadding: true,
                            );
                          }
                        } else {
                          if (sameUserSentPrevMsg) {
                            return MessageCardType3(message: message);
                          } else {
                            return MessageCardType2(message: message);
                          }
                        }
                      }),
                    );
                  },
                ),
              ),
              const Divider(
                height: 1,
              ),
              Material(
                elevation: 10,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: screenInfo.rightPadding + 10,
                      top: 10.0,
                      bottom: bottomPadding,
                    ),
                    color: monaMaterialMagenta.shade50.withOpacity(0.50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            child: TextField(
                              controller: _chatController,
                              autofocus: false,
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: "Message...",
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                  vertical: 15.0,
                                ),
                              ),
                              minLines: 1,
                              maxLines: 4,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: CircleAvatar(
                            child: Center(
                              child: IconButton(
                                  onPressed: () {
                                    _sendMessage();
                                  },
                                  icon: const Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabletPortraitBody(ScreenInformation screenInfo) {
    final Size screenSize = screenInfo.entireScreenSize;

    double bottomPadding =
        screenInfo.bottomViewInsets + screenInfo.bottomPadding + 10;

    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        _removeFocus();
      },
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.20,
            child: Image.asset(
              "assets/chat_background/tablet_portrait.png",
              width: screenSize.width,
              height: screenSize.height,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Material(
                elevation: 10.0,
                child: Container(
                  padding: EdgeInsets.only(
                    top: screenInfo.topPadding,
                    left: screenSize.width * 0.02,
                    right: screenSize.width * 0.02,
                  ),
                  height: screenInfo.topPadding + screenSize.height * 0.10,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xFF05836c),
                        Color(0xFF03735d),
                        Color(0xFF00634f),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child:
                            LayoutBuilder(builder: (lbContext, lbConstraints) {
                          final double availableHeight =
                              lbConstraints.maxHeight;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "ID:$_roomIDForUsers",
                                style: TextStyle(
                                  fontSize: availableHeight * 0.33,
                                  fontFamily: "roboto-mono-medium",
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: availableHeight * 0.025,
                              ),
                              Text(
                                _roomName,
                                style: TextStyle(
                                    fontSize: availableHeight * 0.20,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        }),
                      ),
                      SizedBox(
                        width: screenSize.width * 0.05,
                      ),
                      _getLeaveIcon(),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 1,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: widget.chatRoom.chatDocumentReference.snapshots(),
                  builder:
                      (BuildContext chatBodyContext, AsyncSnapshot snapshot) {
                    //if error happened retrieving the chat snapshot
                    if (snapshot.hasError) {
                      return const MonAFailureAnimation(
                        size: 20,
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }

                    final List<dynamic> messages;

                    try {
                      messages = snapshot.data.data()["messages"];
                    } catch (e) {
                      if (widget.chatUser.userType == UserType.joinedRoom) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Card(
                              color: MonAColors.darkWarmRed,
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 15.0),
                                child: SizedBox(
                                  width: screenSize.width - 40,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        appLocalizations
                                            .chat_deleted_by_creator,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: "cera-gr-medium",
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 25.0,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<ChatBloc>()
                                              .add(const GoBack());
                                        },
                                        child: Text(
                                          appLocalizations.leave,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: "cera-gr-bold",
                                            color: Colors.black,
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      // return nothing if the user is the creator
                      return Container();
                    }

                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      controller: _listViewScrollController,
                      padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 5,
                          right: screenInfo.rightPadding + 5),
                      itemBuilder: ((liViewContext, index) {
                        index = messages.length - (index + 1);

                        final Message message = Message(messages[index]);

                        final bool sentByMe =
                            message.senderID == widget.chatUser.userID;

                        final bool sameUserSentPrevMsg =
                            message.sameUserSentPrevMessage(
                                prevMessageSenderID: index > 0
                                    ? messages[index - 1]["senderID"]
                                    : "");

                        if (sentByMe) {
                          if (sameUserSentPrevMsg) {
                            return MessageCardType1(message: message);
                          } else {
                            return MessageCardType1(
                              message: message,
                              extraTopPadding: true,
                            );
                          }
                        } else {
                          if (sameUserSentPrevMsg) {
                            return MessageCardType3(message: message);
                          } else {
                            return MessageCardType2(message: message);
                          }
                        }
                      }),
                    );
                  },
                ),
              ),
              const Divider(
                height: 1,
              ),
              Material(
                elevation: 10,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: screenInfo.rightPadding + 10,
                      top: 10.0,
                      bottom: bottomPadding,
                    ),
                    color: monaMaterialMagenta.shade50.withOpacity(0.50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            child: TextField(
                              controller: _chatController,
                              autofocus: false,
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: "Message...",
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                  vertical: 15.0,
                                ),
                              ),
                              minLines: 1,
                              maxLines: 4,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: CircleAvatar(
                            child: Center(
                              child: IconButton(
                                  onPressed: () {
                                    _sendMessage();
                                  },
                                  icon: const Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLandscapeBody(ScreenInformation screenInfo) {
    final Size screenSize = screenInfo.entireScreenSize;

    double bottomPadding =
        screenInfo.bottomViewInsets + screenInfo.bottomPadding + 10;

    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        _removeFocus();
      },
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.20,
            child: Image.asset(
              "assets/chat_background/tablet_landscape.png",
              width: screenSize.width,
              height: screenSize.height,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Material(
                elevation: 10.0,
                child: Container(
                  padding: EdgeInsets.only(
                    top: screenInfo.topPadding + 10,
                    left: screenSize.width * 0.02,
                    right: screenSize.width * 0.02,
                  ),
                  height: screenInfo.topPadding + screenSize.height * 0.125,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xFF05836c),
                        Color(0xFF03735d),
                        Color(0xFF00634f),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child:
                            LayoutBuilder(builder: (lbContext, lbConstraints) {
                          final double availableHeight =
                              lbConstraints.maxHeight;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "ID:$_roomIDForUsers",
                                style: TextStyle(
                                  fontSize: availableHeight * 0.33,
                                  fontFamily: "roboto-mono-medium",
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: availableHeight * 0.025,
                              ),
                              Text(
                                _roomName,
                                style: TextStyle(
                                    fontSize: availableHeight * 0.20,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        }),
                      ),
                      SizedBox(
                        width: screenSize.width * 0.05,
                      ),
                      _getLeaveIcon(),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 1,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: widget.chatRoom.chatDocumentReference.snapshots(),
                  builder:
                      (BuildContext chatBodyContext, AsyncSnapshot snapshot) {
                    //if error happened retrieving the chat snapshot
                    if (snapshot.hasError) {
                      return const MonAFailureAnimation(
                        size: 20,
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }

                    final List<dynamic> messages;

                    try {
                      messages = snapshot.data.data()["messages"];
                    } catch (e) {
                      if (widget.chatUser.userType == UserType.joinedRoom) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Card(
                              color: MonAColors.darkWarmRed,
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 15.0),
                                child: SizedBox(
                                  width: screenSize.width - 40,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        appLocalizations
                                            .chat_deleted_by_creator,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: "cera-gr-medium",
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 25.0,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<ChatBloc>()
                                              .add(const GoBack());
                                        },
                                        child: Text(
                                          appLocalizations.leave,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: "cera-gr-bold",
                                            color: Colors.black,
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      // return nothing if the user is the creator
                      return Container();
                    }

                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      controller: _listViewScrollController,
                      padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 5,
                          right: screenInfo.rightPadding + 5),
                      itemBuilder: ((liViewContext, index) {
                        index = messages.length - (index + 1);

                        final Message message = Message(messages[index]);

                        final bool sentByMe =
                            message.senderID == widget.chatUser.userID;

                        final bool sameUserSentPrevMsg =
                            message.sameUserSentPrevMessage(
                                prevMessageSenderID: index > 0
                                    ? messages[index - 1]["senderID"]
                                    : "");

                        if (sentByMe) {
                          if (sameUserSentPrevMsg) {
                            return MessageCardType1(message: message);
                          } else {
                            return MessageCardType1(
                              message: message,
                              extraTopPadding: true,
                            );
                          }
                        } else {
                          if (sameUserSentPrevMsg) {
                            return MessageCardType3(message: message);
                          } else {
                            return MessageCardType2(message: message);
                          }
                        }
                      }),
                    );
                  },
                ),
              ),
              const Divider(
                height: 1,
              ),
              Material(
                elevation: 10,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: screenInfo.rightPadding + 10,
                      top: 10.0,
                      bottom: bottomPadding,
                    ),
                    color: monaMaterialMagenta.shade50.withOpacity(0.50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            child: TextField(
                              controller: _chatController,
                              autofocus: false,
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: "Message...",
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                  vertical: 15.0,
                                ),
                              ),
                              minLines: 1,
                              maxLines: 4,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: CircleAvatar(
                            child: Center(
                              child: IconButton(
                                  onPressed: () {
                                    _sendMessage();
                                  },
                                  icon: const Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ##########################################################################

  /// Sends a message
  void _sendMessage() async {
    // read the text
    final String message = _chatController.text;

    // clear the TextField
    _chatController.clear();

    if (message.isEmpty || RegExp(r"^\s+$").hasMatch(message)) return;

    try {
      // send the message
      await FirebaseDBWrapper.sendMessage(
          message: message,
          chatRoomRef: widget.chatRoom.chatDocumentReference,
          user: widget.chatUser);

      _listViewScrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    } catch (e) {
      // do nothing
    }
  }

  /// Zooms In on room ID
  void _zoomInRoomID() async {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Zoom In Dialogue",
      pageBuilder: (_, __, ___) {
        final ScreenInformation screenInformation =
            ScreenInformation.fromMediaQueryData(
          mediaQueryData: MediaQuery.of(context),
        );

        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.0),
            ),
            margin: EdgeInsets.symmetric(
              horizontal: screenInformation.entireScreenSize.width * 0.05,
            ),
            padding: const EdgeInsets.all(6.0),
            child: SizedBox.expand(
              child: Material(
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        _roomIDForUsers,
                        style: const TextStyle(
                          fontSize: 100,
                          fontFamily: "roboto-mono-medium",
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const CircleAvatar(
                          radius: 16.0,
                          backgroundColor: MonAColors.darkWarmRed,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Returns leave icon based on UserType
  IconButton _getLeaveIcon() {
    final bool userCreatedRoom =
        widget.chatUser.userType == UserType.createdRoom;

    return IconButton(
      onPressed: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel: "Leave or delete Chat Room",
          pageBuilder: (_, __, ___) {
            return DeleteLeaveDialog(
              chatRoom: widget.chatRoom,
              roomRemovalTask: userCreatedRoom
                  ? RoomRemovalTask.delete
                  : RoomRemovalTask.leave,
              parentContext: context,
            );
          },
        );
      },
      icon: Icon(
        userCreatedRoom ? Icons.delete_forever : Icons.exit_to_app,
        color: Colors.white,
      ),
    );
  }
}

// ############################################################################

enum RoomRemovalTask { delete, leave }

class DeleteLeaveDialog extends StatefulWidget {
  final ChatRoom chatRoom;
  final RoomRemovalTask roomRemovalTask;
  final BuildContext parentContext;

  const DeleteLeaveDialog(
      {Key? key,
      required this.chatRoom,
      required this.roomRemovalTask,
      required this.parentContext})
      : super(key: key);

  @override
  _DeleteLeaveDialogState createState() => _DeleteLeaveDialogState();
}

class _DeleteLeaveDialogState extends State<DeleteLeaveDialog> {
  bool _taskCompleted = false;
  bool _taskInProgress = false;
  bool _errorOccurred = false;

  @override
  Widget build(BuildContext context) {
    final ScreenInformation screenInfo = ScreenInformation.fromMediaQueryData(
      mediaQueryData: MediaQuery.of(context),
    );

    final Size screenSize = screenInfo.entireScreenSize;

    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.05,
        ),
        padding:
            const EdgeInsets.only(left: 30, right: 15, top: 20, bottom: 10),
        child: SizedBox.expand(
          child: Material(
            child: Container(color: Colors.white, child: _buildDialogBody()),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogBody() {
    if (_errorOccurred) {
      return const MonAFailureAnimation(
        size: 30.0,
      );
    }

    if (!_taskCompleted && !_taskInProgress) {
      final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

      final String task = widget.roomRemovalTask == RoomRemovalTask.delete
          ? appLocalizations.chat_delete_room
          : appLocalizations.chat_leave_room;

      final String taskAction = widget.roomRemovalTask == RoomRemovalTask.delete
          ? appLocalizations.delete
          : appLocalizations.leave;

      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task,
            style: const TextStyle(
              color: Colors.black87,
              fontFamily: "roboto",
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text(
                  appLocalizations.cancel,
                  style: const TextStyle(
                      fontFamily: "roboto",
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                onPressed: widget.roomRemovalTask == RoomRemovalTask.delete
                    ? _deleteRoom
                    : _leaveRoom,
                child: Text(
                  taskAction,
                  style: const TextStyle(
                      fontFamily: "roboto",
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          )
        ],
      );
    }

    if (!_taskCompleted && _taskInProgress) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return const MonASuccessAnimation(
      size: 30,
    );
  }

  void _leaveRoom() async {
    try {
      setState(() {
        _taskInProgress = true;
      });

      await FirebaseDBWrapper.signOut();

      setState(() {
        _taskCompleted = true;
      });

      Future.delayed(const Duration(milliseconds: 1800), () {
        Navigator.pop(context);
        widget.parentContext.read<ChatBloc>().add(const GoBack());
      });
    } catch (e) {
      setState(() {
        _errorOccurred = true;
      });
    }
  }

  void _deleteRoom() async {
    try {
      setState(() {
        _taskInProgress = true;
      });

      await FirebaseDBWrapper.deleteRoom(
        chatRoom: widget.chatRoom,
      );

      await FirebaseDBWrapper.signOut();

      setState(() {
        _taskCompleted = true;
      });

      Future.delayed(const Duration(milliseconds: 1800), () {
        Navigator.pop(context);
        widget.parentContext.read<ChatBloc>().add(const GoBack());
      });
    } catch (e) {
      setState(() {
        _errorOccurred = true;
      });
    }
  }
}
