part of 'view.dart';

class ChatInitialAnimatedBody extends StatefulWidget {
  const ChatInitialAnimatedBody({Key? key}) : super(key: key);

  @override
  _ChatInitialAnimatedBodyState createState() =>
      _ChatInitialAnimatedBodyState();
}

class _ChatInitialAnimatedBodyState extends State<ChatInitialAnimatedBody>
    with TickerProviderStateMixin {
  // animation stuff
  late AnimationController _animController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
    _animation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.fastLinearToSlowEaseIn,
    ));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: const ChatInitialBody(),
    );
  }
}
