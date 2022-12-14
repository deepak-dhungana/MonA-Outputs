import 'package:flutter/material.dart';
import '../responsive_and_adaptive/screen_info.dart';

class MonAPartnerCard extends StatefulWidget {
  final double cardWidth;
  final int index;

  const MonAPartnerCard({
    Key? key,
    required this.cardWidth,
    required this.index,
  }) : super(key: key);

  @override
  _MonAPartnerCardState createState() => _MonAPartnerCardState();
}

class _MonAPartnerCardState extends State<MonAPartnerCard>
    with AutomaticKeepAliveClientMixin {
  // Pre-cached MonA Logo
  late Image partnerLogo;

  @override
  void initState() {
    super.initState();

    partnerLogo = Image.asset(
      "assets/partners_logo/${widget.index}.jpg",
    );
  }

  @override
  void didChangeDependencies() {
    precacheImage(partnerLogo.image, context);
    super.didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final ScreenInformation screenInfo = ScreenInformation.fromMediaQueryData(
      mediaQueryData: MediaQuery.of(context),
    );

    return _buildBodyByScreenType(screenInfo);
  }

  Widget _buildBodyByScreenType(ScreenInformation screenInfo) {
    switch (screenInfo.screenType) {
      case ScreenType.mobilePortrait:
        return _buildMobilePortraitBody();

      case ScreenType.mobileLandscape:
        return _buildMobileLandscapeBody();

      case ScreenType.tabletPortrait:
        return _buildTabletPortraitBody();

      case ScreenType.tabletLandscape:
        return _buildTabletLandscapeBody();
    }
  }

  Widget _buildMobilePortraitBody() {
    return Center(
      child: SizedBox(
        height: widget.cardWidth * 0.5,
        width: widget.cardWidth,
        child: Card(
          elevation: 8.0,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: widget.cardWidth * 0.053,
              horizontal: widget.index == 0
                  ? widget.cardWidth * 0.132
                  : widget.cardWidth * 0.079,
            ),
            child: partnerLogo,
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLandscapeBody() {
    return Center(
      child: SizedBox(
        height: widget.cardWidth * 0.3,
        width: widget.cardWidth,
        child: Card(
          elevation: 8.0,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: widget.cardWidth * 0.053,
              horizontal: widget.index == 0
                  ? widget.cardWidth * 0.132
                  : widget.cardWidth * 0.079,
            ),
            child: partnerLogo,
          ),
        ),
      ),
    );
  }

  Widget _buildTabletPortraitBody() {
    return Center(
      child: SizedBox(
        height: widget.cardWidth * 0.3,
        width: widget.cardWidth,
        child: Card(
          elevation: 8.0,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: widget.cardWidth * 0.053,
              horizontal: widget.index == 0
                  ? widget.cardWidth * 0.132
                  : widget.cardWidth * 0.079,
            ),
            child: partnerLogo,
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLandscapeBody() {
    return Center(
      child: SizedBox(
        height: widget.cardWidth * 0.3,
        width: widget.cardWidth,
        child: Card(
          elevation: 8.0,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: widget.cardWidth * 0.053,
              horizontal: widget.index == 0
                  ? widget.cardWidth * 0.132
                  : widget.cardWidth * 0.079,
            ),
            child: partnerLogo,
          ),
        ),
      ),
    );
  }
}
