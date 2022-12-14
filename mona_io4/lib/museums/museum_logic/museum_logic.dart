import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http show get;

import '../../app_config/app_config.dart';

class MuseumUtil {
  /// Fetches folder names for museums
  static Future<List<String>> getMuseumFoldersName() async {
    try {
      final Map<String, String> headers = {
        "Mona-Key": MonAConfiguration.monaAppKey
      };

      final response = await http.get(
          Uri.parse(MonAConfiguration.listMuseumsScript),
          headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse["success"] == true) {
          List<String> folderNames = [];

          jsonResponse["result"].forEach((folderName) {
            // check that the names are folders and not files
            if (!RegExp(r".+\.[a-z]+$").hasMatch(folderName)) {
              folderNames.add(folderName);
            }
          });

          // returns the lexically sorted list
          return folderNames..sort();
        } else {
          throw Exception(
              "getMuseumFoldersName(): Failed to fetch file names.");
        }
      } else {
        throw Exception("getMuseumFoldersName(): Failed to fetch file names.");
      }
    } catch (e) {
      throw Exception("getMuseumFoldersName(): Failed to fetch file names.");
    }
  }

  // ###########################################################################
  /// Fetches the contents inside a given folder name
  static Future<List<String>> getContentsFromMuseumFolder(
      {required String folderName}) async {
    try {
      final Map<String, String> headers = {
        "Folder-Name": folderName,
        "Mona-Key": MonAConfiguration.monaAppKey
      };

      final response = await http.get(
          Uri.parse(MonAConfiguration.listMuseumContents),
          headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);


        if (jsonResponse["success"] == true) {
          return jsonResponse["result"].cast<String>();
        } else {
          throw Exception(
              "getContentsFromMuseumFolder(): Failed to fetch file names.");
        }
      } else {
        throw Exception(
            "getContentsFromMuseumFolder(): Failed to fetch file names.");
      }
    } catch (e) {
      throw Exception(
          "getContentsFromMuseumFolder(): Failed to fetch file names.");
    }
  }

  // ###########################################################################

  /// Downloads a file from the given URL
  static Future<Uint8List> downloadMuseumFile({required String url}) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception("Failed to download file");
      }
    } catch (e) {
      throw Exception("Failed to download file");
    }
  }

  /// Downloads a image from the given URL
  static Future<Uint8List> downloadMuseumImage(
      {required String imageURL}) async {
    try {
      final response = await http.get(Uri.parse(imageURL));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception("Failed to download file");
      }
    } catch (e) {
      throw Exception("Failed to download file");
    }
  }
}
