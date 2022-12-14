// *** FTP is not secured ***

import 'dart:async';

// Encoders and decoders for converting between different data representations.
import 'dart:convert' show Encoding, Utf8Codec;

// Browser-based apps can't use this library.
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../app_config/app_config.dart';

// file transfer modes for FTP
enum TransferMode { binary, ascii }

class MonAFTPClient {
  final bool debug;

  MonAFTPClient({required this.debug});

  // raw socket connection to connect to FTP server.
  // Initialized in connect() method.
  late RawSocket _rawSocket;

  static const Encoding _codec = Utf8Codec();
  static const int _timeout = 30; // in Seconds

  // FTP servers always use port 21
  static const int _ftpPort = 21;

  // directory where the file gets saved
  static const String downloadFolder = "Downloads";

  // HOST, USERNAME and PASSWORD for FTP Server is defined in
  // app_config/app_config.dart file.

  // ************************** Private Methods *******************************

  /// Read response from the server
  Future<String> _readResponseFromServer() async {
    int lengthOfBytesToRead = 0;

    StringBuffer responseBuffer = StringBuffer();

    await Future.doWhile(() async {
      if (lengthOfBytesToRead > 0) {
        responseBuffer
            .write(_codec.decode(_rawSocket.read(lengthOfBytesToRead)!));
      }

      lengthOfBytesToRead = _rawSocket.available();

      if (lengthOfBytesToRead > 0 || responseBuffer.length == 0) {
        await Future.delayed(const Duration(milliseconds: 100));
        // 100 millisecond pause seems to be the best performing
        return true;
      }

      return false;
    }).timeout(const Duration(seconds: _timeout));

    String response = responseBuffer.toString().trimRight();

    if (debug) {
      // ignore: avoid_print
      print(response);
    }

    return response;
  }

  /// Sends command to server.
  Future<void> _sendCommandToServer(String command) async {
    if (_rawSocket.available() > 0) {
      _readResponseFromServer();
    }
    _rawSocket.write(_codec.encode("$command\r\n"));
  }

  /// Checks the return code with given code
  Future<void> _checkFTPReturnCode(int code, String message) async {
    String response = await _readResponseFromServer();

    if (!response.startsWith(code.toString())) {
      throw FTPException(message: message);
    }
  }

  /// Sets FTP transfer mode to given mode. Either binary or ascii.
  Future<void> _setTransferMode(TransferMode mode) async {
    switch (mode) {
      case TransferMode.ascii:
        await _sendCommandToServer("TYPE A");
        await _checkFTPReturnCode(
            200, "ascii transfer mode is not accepted..!");
        break;

      case TransferMode.binary:
        await _sendCommandToServer("TYPE I");
        await _checkFTPReturnCode(
            200, "BINARY transfer mode is not accepted..!");
        break;

      default:
        break;
    }
  }

  /// Static utility function for parsing the port response
  static Future<int> _parsePort(String response) async {
    int iParOpen = response.indexOf('(');
    int iParClose = response.indexOf(')');

    String parameters = response.substring(iParOpen + 1, iParClose);
    List<String> lstParameters = parameters.split(',');

    int iPort1 = int.parse(lstParameters[lstParameters.length - 2]);
    int iPort2 = int.parse(lstParameters[lstParameters.length - 1]);

    return (iPort1 * 256) + iPort2;
  }

  /// returns given file size in bytes
  Future<int> _getFileSize(String fileName) async {
    int size = -1;
    try {
      // send command
      await _sendCommandToServer("SIZE $fileName");

      // get response
      String response = await _readResponseFromServer();

      if (response.startsWith("213")) {
        size = int.parse(response.split(" ")[1]);
      }
    } catch (e) {
      if (debug) {
        // ignore: avoid_print
        print(e);
      }
    }
    return size;
  }

  /// returns the local file
  static Future<File> _getLocalFile(String fileName) async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory() // for android
        : await getApplicationDocumentsDirectory(); // for ios

    String dirPath =
        directory!.path + Platform.pathSeparator + MonAConfiguration.appFolder;

    if (Platform.isAndroid) {
      final RegExpMatch dirPathMatch =
          RegExp("(.+)/Android/.+", caseSensitive: false)
              .firstMatch(directory.path)!;

      assert(dirPathMatch.group(1) != null, "Directory path cant be null");

      dirPath = dirPathMatch.group(1)! +
          Platform.pathSeparator +
          "Documents" +
          Platform.pathSeparator +
          MonAConfiguration.appFolder;
    }

    final saveDirectory = Directory(dirPath);

    bool directoryExists = await saveDirectory.exists();

    if (!directoryExists) {
      await saveDirectory.create(recursive: true);
    }

    // from here onwards, a check is done to see if there are
    // already files with the same name.

    // final List<FileSystemEntity> existingFileNames = saveDirectory.listSync();
    //
    // int count = 0;
    //
    // final List<String> splitFileName = fileName.split(".");
    //
    // for (var element in existingFileNames) {
    //   // checks if the given file name is as same as this file
    //   if (RegExp(splitFileName[0]).hasMatch(element.path)) {
    //     count += 1;
    //   }
    // }

    String filePath = saveDirectory.path + Platform.pathSeparator + fileName;

    // // if there are more files under same name, then rename it
    // if (count > 0) {
    //   filePath = saveDirectory.path +
    //       Platform.pathSeparator +
    //       splitFileName[0] +
    //       " ($count)." +
    //       splitFileName[1];
    // } else {
    //   filePath = saveDirectory.path + Platform.pathSeparator + fileName;
    // }

    return File(filePath);
  }

  // ************************** Public Methods *******************************

  /// Connects to the FTP server and instantiate _rawSocket
  Future<void> connect() async {
    try {
      // instantiate raw socket
      _rawSocket = await RawSocket.connect(MonAConfiguration.host, _ftpPort,
          timeout: const Duration(seconds: _timeout));

      await _checkFTPReturnCode(220, "Error Connecting to the FTP server...!");

      // send username
      await _sendCommandToServer("USER ${MonAConfiguration.username}");

      await _checkFTPReturnCode(331, "Wrong Username...!");

      // send password
      await _sendCommandToServer("PASS ${MonAConfiguration.password}");

      await _checkFTPReturnCode(230, "Wrong Password...!");

      if (debug) {
        // ignore: avoid_print
        print("Connected...");
      }
    } catch (e) {
      throw FTPException(message: "Cannot connect to the FTP server...");
    }
  }

  /// Disconnects from FTP server
  Future<void> disconnect() async {
    try {
      // don't use _sendCommandToServer().
      _rawSocket.write(_codec.encode("QUIT\r\n"));

      await _rawSocket.close();

      _rawSocket.shutdown(SocketDirection.both);
    } catch (e) {
      throw FTPException(message: "Failed to disconnect...");
    }
  }

  /// Retrieves the list of file names in a directory
  Future<List<String>> listDirectory() async {
    // set ASCII mode
    await _setTransferMode(TransferMode.ascii);

    // enter passive mode
    await _sendCommandToServer("PASV");

    String response = await _readResponseFromServer();

    if (debug) {
      // ignore: avoid_print
      print("response: $response");
    }

    if (!response.startsWith("227")) {
      throw FTPException(message: "Cannot enter passive mode...!");
    }

    // // parse the port from retrieved response
    int passivePort = await _parsePort(response);

    // send command for retrieving list of file names
    await _sendCommandToServer("NLST");

    // create a new connection wit the port
    final Socket fileListSocket =
        await Socket.connect(MonAConfiguration.host, passivePort);

    List<int> fileNamesInInt = [];

    // receive data
    await fileListSocket.listen((data) {
      fileNamesInInt.addAll(data);
    }).asFuture();

    // close the newly created socket connection
    await fileListSocket.close();

    return _codec.decode(fileNamesInInt).trimRight().split("\n");
  }

  /// Change directory to a given directory
  Future<void> changeDirectory(String dirName) async {
    await _sendCommandToServer("CWD $dirName");
    await _checkFTPReturnCode(250, "No such directory...!");
  }

  /// Downloads a given file
  Future<void> downloadFile(
      {required String fileName, required Function onDownloadProgress}) async {
    // set transfer mode to binary
    await _setTransferMode(TransferMode.binary);

    // retrieve file-size
    int fileSize = await _getFileSize(fileName);

    if (fileSize == -1) {
      throw FTPException(
          message: "NO such file in the specified directory...!");
    }

    // initiate passive mode
    await _sendCommandToServer("PASV");

    String response = await _readResponseFromServer();

    if (!response.startsWith("227")) {
      throw FTPException(message: "Cannot enter passive mode...!");
    }

    // parse the port from retrieved response
    int passivePort = await _parsePort(response);

    // send command for file retrieval
    // the response will be the file,
    // which will be loaded with another socket
    await _sendCommandToServer("RETR $fileName");

    // create a new connection wit the port
    final Socket fileDownloadSocket =
        await Socket.connect(MonAConfiguration.host, passivePort);

    final File localFile = await _getLocalFile(fileName);

    final IOSink localFileSink = localFile.openWrite();

    double downloaded = 0;

    // don't use await
    fileDownloadSocket.listen((data) {

      localFileSink.add(data);

      downloaded += data.length;

      double downloadProgressPercentage =
          double.parse((downloaded / fileSize).toStringAsFixed(2));

      // call the callback function
      onDownloadProgress(downloadProgressPercentage);
    })
      ..onDone(() async {

        await localFileSink.flush();
        await localFileSink.close();

        if (debug) {
          // ignore: avoid_print
          print("Download Complete...!");
        }
      })
      ..onError((error) {
        throw FTPException(
            message: "downloadFile(): Error Downloading File...");
      });

    await fileDownloadSocket.close();
  }
}

class FTPException implements Exception {
  final String message;

  FTPException({required this.message});

  @override
  String toString() {
    return 'FTPException: $message';
  }
}
