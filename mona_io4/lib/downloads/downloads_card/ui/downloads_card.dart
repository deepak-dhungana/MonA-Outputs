import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mona/colors.dart';
import 'package:mona/downloads/downloads_card/downloads_bloc/card_bloc.dart';
import 'package:mona/downloads/downloads_logic/downloads_logic.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mona/downloads/pdf_view/mona_pdf_view.dart';
import 'package:mona/widgets/failure_anim.dart';
import 'package:mona/widgets/success_anim.dart';

class DCardView extends StatefulWidget {
  final MonAPDFFile pdfFile;
  final double cardWidth;
  final double cardHeight;
  final int colorIndex;

  const DCardView(
      {Key? key,
      required this.pdfFile,
      required this.cardWidth,
      required this.cardHeight,
      required this.colorIndex})
      : super(key: key);

  @override
  _DCardViewState createState() => _DCardViewState();
}

class _DCardViewState extends State<DCardView>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  // border radius of the card
  static const double kCardBorderRadius = 6.0;

  @override
  bool get wantKeepAlive => true;

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
      begin: const Offset(1, 0),
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
    super.build(context);
    return SlideTransition(
      position: _animation,
      child: Center(
        child: Card(
          child: SizedBox(
            height: widget.cardHeight,
            width: widget.cardWidth,
            child: BlocBuilder<DCardBloc, DCardState>(
              builder: (blocContext, state) {
                return _mapStateToTopLayer(
                  BlocProvider.of<DCardBloc>(context),
                  context,
                );
              },
            ),
          ),
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kCardBorderRadius),
          ),
        ),
      ),
    );
  }

  Widget _mapStateToTopLayer(DCardBloc cardBloc, BuildContext context) {
    final DCardState currentState = cardBloc.state;

    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    if (currentState is DCardInitial) {
      return LayoutBuilder(builder: (lbContext, lbConstraints) {
        final double availableHeight = lbConstraints.maxHeight;

        return Column(
          children: <Widget>[
            Container(
                height: availableHeight * 0.70,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xFFf3c600),
                      Color(0xFFf2bd00),
                      Color(0xFFf3af00),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(kCardBorderRadius),
                    topRight: Radius.circular(kCardBorderRadius),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset(
                        "assets/images/dcard_yellow.png",
                        width: widget.cardWidth * 0.70,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20.0, right: 20.0),
                        child: Text(
                          widget.pdfFile.fileNameWithoutExt.toUpperCase(),
                          style: TextStyle(
                              fontFamily: "roboto",
                              fontWeight: FontWeight.w700,
                              fontSize: availableHeight * 0.12,
                              color: Colors.black,
                              height: 1),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: true,
                        ),
                      ),
                    ),
                  ],
                )),
            Container(
              height: availableHeight * 0.30,
              decoration: BoxDecoration(
                color: monaMaterialMagenta,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(kCardBorderRadius),
                  bottomRight: Radius.circular(kCardBorderRadius),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      if (kIsWeb) {
                        DownloadsUtil.downloadFileWeb(
                          url: widget.pdfFile.entireURL,
                          fileName: widget.pdfFile.fileNameWithoutExt,
                        );
                        return;
                      }
                      cardBloc.add(const DCardPermissionRequested());
                      return;
                    },
                    child: Text(
                      appLocalizations.download,
                      style: const TextStyle(
                        fontFamily: "cera-gr-bold",
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MonAPDFView(
                          pdfFile: widget.pdfFile,
                        );
                      }));
                    },
                    child: Text(
                      appLocalizations.read,
                      style: const TextStyle(
                        fontFamily: "cera-gr-bold",
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  )
                ],
              ),
            ),
          ],
        );
      });
    }

    if (currentState is DCardDownloadInProgress) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(kCardBorderRadius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.arrow_circle_down_rounded,
                color: monaMaterialMagenta,
                size: 40,
              ),
              const SizedBox(
                height: 20.0,
              ),
              LinearProgressIndicator(
                minHeight: 5.0,
                value: currentState.progress,
                valueColor: AlwaysStoppedAnimation<Color>(
                  monaMaterialMagenta,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (currentState is DCardDownloadSuccess) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(kCardBorderRadius),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: MonASuccessAnimation(
            size: 40,
          ),
        ),
      );
    }

    if (currentState is DCardDownloadFailure) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(kCardBorderRadius),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: MonAFailureAnimation(
            size: 30,
          ),
        ),
      );
    }

    if (currentState is DCardDownloadConfiguring) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container();
  }
}
