import 'dart:async';

class EventManager {
  final Map<String, StreamController<dynamic>> _eventController = {};

  void addEvent(String name) {
    _eventController[name] = StreamController<dynamic>.broadcast();
  }

  void clear() async {
    // await Future.wait(_eventController.values.map((e) => e.close()));
    _eventController.clear();
  }

  void triggerEvent(String name, dynamic event) {
    _eventController[name]?.add(event);
  }

  void triggerError(String name, Object error) {
    _eventController[name]?.addError(error);
  }

  Future<dynamic> waitForEvent(String name) {
    return _eventController[name]?.stream.first ?? (throw Exception("wrong event name"));
  }

  Future<dynamic> waitForResolveWithKey(int key) {
    return _eventController['resolve']
            ?.stream
            .where((event) => (int.parse(event['key']) == key))
            .map((event) => event['data'])
            .first ??
        (throw Exception("wrong event name"));
  }
}
