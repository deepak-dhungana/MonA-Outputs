class Museum {
  final String museumName;
  final String description;
  final String vrTourURL;
  final String gameURL;
  final String location;

  Museum(
      {required this.museumName,
      required this.description,
      required this.vrTourURL,
      required this.gameURL,
      required this.location});

  Museum.fromJson(Map<String, String> jsonMap)
      : museumName = jsonMap["name"]!,
        description = jsonMap["description"]!,
        vrTourURL = jsonMap["vr_tour_url"]!,
        gameURL = jsonMap["game_url"]!,
        location = jsonMap["location"]!;
}
