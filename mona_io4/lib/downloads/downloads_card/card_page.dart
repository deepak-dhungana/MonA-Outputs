import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ui/downloads_card.dart';
import 'downloads_bloc/card_bloc.dart';
import '../downloads_logic/downloads_logic.dart';

class DownloadsCard extends StatelessWidget {
  final MonAPDFFile pdfFile;
  final double cardWidth;
  final double cardHeight;
  final int colorIndex;

  const DownloadsCard(
      {Key? key,
      required this.pdfFile,
      required this.cardWidth,
      required this.cardHeight,
      required this.colorIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DCardBloc(
        pdfFile: pdfFile,
      ),
      child: DCardView(
        pdfFile: pdfFile,
        cardWidth: cardWidth,
        cardHeight: cardHeight,
        colorIndex: colorIndex,
      ),
    );
  }
}
