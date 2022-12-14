import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mona/colors.dart';
import 'package:mona/downloads/downloads_logic/downloads_logic.dart';
import 'package:mona/responsive_and_adaptive/screen_info.dart';
import 'package:mona/widgets/failure_anim.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MonAPDFView extends StatefulWidget {
  final MonAPDFFile pdfFile;

  const MonAPDFView({Key? key, required this.pdfFile}) : super(key: key);

  @override
  _MonAPDFViewState createState() => _MonAPDFViewState();
}

class _MonAPDFViewState extends State<MonAPDFView> {
  // PDF Document
  late final PdfController _pdfController;

  // for state management
  // PDF file downloaded successfully
  bool _pdfDownloaded = false;

  // an error has occurred while downloading the PDF file
  bool _errorDownloadingPDF = false;

  late final int numOfPages;

  final TextEditingController _pageNumController = TextEditingController();

  // Scaffold messenger key for error SnackBar
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  late final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

  @override
  void initState() {
    // start downloading the PDF document
    _downloadPDFDocument();

    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenInformation screenInfo = ScreenInformation.fromMediaQueryData(
      mediaQueryData: MediaQuery.of(context),
    );

    final Size screenSize = screenInfo.entireScreenSize;

    if (_errorDownloadingPDF) {
      return ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: const Center(
            child: MonAFailureAnimation(size: 60.0),
          ),
        ),
      );
    }

    if (!_pdfDownloaded) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const CircularProgressIndicator(),
              const SizedBox(
                height: 30,
              ),
              Text(
                appLocalizations.loading_document,
                style: const TextStyle(
                    fontSize: 18.0, fontFamily: "cera-gr-medium",),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black.withOpacity(0.60),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.pdfFile.fileNameWithoutExt,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: "cera-gr-regular",
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 2,
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.black.withOpacity(0.60),
            ),
            onPressed: () {
              _shareFile();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PdfView(
              physics: const NeverScrollableScrollPhysics(),
              documentLoader: const Center(child: CircularProgressIndicator()),
              pageLoader: const Center(child: CircularProgressIndicator()),
              errorBuilder: (exception) {
                return const Center(child: MonAFailureAnimation(size: 60.0));
              },
              pageSnapping: false,
              backgroundDecoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
              ),
              controller: _pdfController,
              onDocumentLoaded: (doc) {
                numOfPages = doc.pagesCount;
                _pageNumController.text = "1 / $numOfPages";
              },
              onPageChanged: (pageNum) {
                _pageNumController.text = "$pageNum / $numOfPages";
              },
              pageBuilder: (
                Future<PdfPageImage> pageImage,
                int index,
                PdfDocument document,
              ) =>
                  PhotoViewGalleryPageOptions(
                imageProvider: PdfPageImageProvider(
                  pageImage,
                  index,
                  document.id,
                ),
                minScale: PhotoViewComputedScale.contained * 1,
                maxScale: PhotoViewComputedScale.contained * 5,
                initialScale: PhotoViewComputedScale.contained * 1,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: screenInfo.bottomPadding),
            width: screenSize.width,
            height: screenInfo.bottomPadding + 56,
            color: monaMaterialMagenta.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      _pdfController.jumpToPage(1);
                    },
                    icon: const Icon(Icons.first_page_rounded)),
                IconButton(
                  onPressed: () {
                    _pdfController.previousPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn);
                  },
                  icon: const Icon(Icons.navigate_before_rounded),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 120,
                  height: 30,
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                      ),
                    ),
                    showCursor: false,
                    controller: _pageNumController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20.0),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    _pdfController.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut);
                  },
                  icon: const Icon(Icons.navigate_next_rounded),
                ),
                IconButton(
                  onPressed: () {
                    _pdfController.jumpToPage(numOfPages);
                  },
                  icon: const Icon(Icons.last_page_rounded),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ###########################################################################

  void _downloadPDFDocument() async {
    try {
      final Uint8List pdfFileBytes = await DownloadsUtil.downloadFileWebCached(
          url: widget.pdfFile.entireURL);

      _pdfController = PdfController(
        document: PdfDocument.openData(pdfFileBytes),
      );

      if (mounted) {
        setState(() {
          _pdfDownloaded = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorDownloadingPDF = true;
        });
        Future.delayed(const Duration(milliseconds: 500),(){
          _showErrorSnackBar(
            appLocalizations.document_open_error,
            const Duration(days: 365),
          );

        });
      }
    }
  }

  Future<void> _shareFile() async {
    Share.share(widget.pdfFile.entireURL);
    return;
  }

  void _showErrorSnackBar(String errorMessage, Duration duration) async {
   _scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        backgroundColor: MonAColors.errorColor,
        duration: duration,
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
}
