import 'dart:typed_data';
import 'dart:convert' show jsonDecode;

import 'package:http/http.dart' as http show get;
import 'package:universal_html/html.dart' as html;

import '../../app_config/app_config.dart';
import '../../mona_ftp_client/mona_ftp_client.dart';

class DownloadsUtil {
  /// Fetches file names for MonA downloads
  static Future<Map> getDownloadsFileNames() async {
    try {
      final Map<String, String> headers = {
        "Mona-Key": MonAConfiguration.monaAppKey
      };

      final response = await http
          .get(Uri.parse(MonAConfiguration.listFileScript), headers: headers);

      if ((response.statusCode == 200)) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse["success"] == true) {
          final Map<String, dynamic> result = jsonResponse["result"];

          result.forEach((key, value) {
            result[key] = value.map((rawURL) {
              // extracts file name and URL
              // group 1: URL
              // group 2: file name with extension
              final RegExpMatch urlMatch = RegExp(
                      "(/(${MonAConfiguration.fileLocation}/.+)/(.+.[a-z]+))\$")
                  .firstMatch(rawURL)!;

              return MonAPDFFile(
                  entireURL: MonAConfiguration.monaBaseURL + urlMatch.group(1)!,
                  fileName: urlMatch.group(3)!,
                  fileNameWithoutExt: urlMatch.group(3)!.split(".")[0],
                  ftpLocation: urlMatch.group(2)!);
            }).toList();
          });

          return result;
        } else {
          throw Exception(
              "getDownloadsFileNames(): Failed to fetch file names.");
        }
      } else {
        throw Exception("getDownloadsFileNames(): Failed to fetch file names.");
      }
    } catch (e) {
      throw Exception("getDownloadsFileNames(): Failed to fetch file names.");
    }
  }

// ###########################################################################

  static Future<void> downloadFileNonWeb(
      {required String fileName,
      required String ftpLocation,
      required Function onDownloadProgress}) async {
    try {
      MonAFTPClient client = MonAFTPClient(debug: false);

      await client.connect();
      await client.changeDirectory(ftpLocation);
      await client.downloadFile(
          fileName: fileName, onDownloadProgress: onDownloadProgress);
      await client.disconnect();
    } catch (e) {
      throw Exception("_downloadFileNonWeb(): Error downloading file");
    }
  }

  static Future<void> downloadFileWeb(
      {required String url, required String fileName}) async {
    try {
      final anchorElement =
          html.document.createElement('a') as html.AnchorElement
            ..href = url
            ..style.display = 'none'
            ..type = 'application/pdf'
            ..download = fileName;

      html.document.body!.children.add(anchorElement);

      anchorElement.click();

      html.document.body!.children.remove(anchorElement);
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      throw Exception("_downloadFileWeb(): Cannot fetch the pdf file");
    }
  }

  static Future<Uint8List> downloadFileWebCached({required String url}) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception("_downloadFileWeb(): Cannot fetch the pdf file");
      }
    } catch (e) {
      throw Exception("_downloadFileWeb(): Cannot fetch the pdf file");
    }
  }
}

// #############################################################################

class MonAPDFFile {
  final String entireURL;
  final String fileName;
  final String fileNameWithoutExt;
  final String ftpLocation;

  MonAPDFFile(
      {required this.entireURL,
      required this.fileName,
      required this.fileNameWithoutExt,
      required this.ftpLocation});

  @override
  String toString() {
    return "Entire URL: $entireURL\n"
        "File Name: $fileName\n"
        "File Name without extension: $fileNameWithoutExt\n"
        "FTP Location: $ftpLocation";
  }
}
