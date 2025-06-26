class JavascriptChannel {
  final String name;
  final OnReceivedJSONObject onReceived;

  const JavascriptChannel({required this.name, required this.onReceived});
}

typedef OnReceivedJSONObject = void Function(Map<String, dynamic>);
