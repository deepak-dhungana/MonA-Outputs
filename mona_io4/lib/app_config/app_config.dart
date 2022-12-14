// Contains configurations that might change at any point of the project.
// Only changing fields here is enough :)

//
// ****************** Take CAUTION BEFORE CHANGING ANYTHING *******************

class MonAConfiguration {
  // to prevent instantiation
  MonAConfiguration._();

  // MonA FTP host
  static const String host = "ftp.21717280951.thesite.link";

  // Username and Password for the MonA app FTP server
  static const String username = "imckrems";
  static const String password = "!krems123!";

  // ##########################################################################

  // MonA App base URL
  static const String monaBaseURL = "https://app.monaproject.eu";

  // MonA App key
  static const String monaAppKey = "853a94f5-4aae-41ca-8f1f-7b7b3d7465ab";

  // location of the PHP script that returns a json map with boolean success
  // and all file names
  static const String listFileScript = monaBaseURL + "/scripts/list_files.php";

  // locations of the PDF files
  static const String fileLocation = "pdf_files";

  // location of the PHP script that returns a json map with boolean success
  // and all folder names
  static const String listMuseumsScript =
      monaBaseURL + "/scripts/list_museums.php";

  // location of the PHP script that returns a json map with boolean success
  // and all folder names
  static const String listMuseumContents =
      monaBaseURL + "/scripts/list_museum_contents.php";

  // location to save file on android/ ios
  // this is where the PDF files and images from IO3 Krems game etc. is saved
  static const String appFolder = "MonA";
}
