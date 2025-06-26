import 'package:os_info_plugin/os_info_plugin.dart';

Future<String> getOSVersion() async {
  var plugin = OsInfoPlugin();
  return await plugin.getPlatformVersion() ?? 'unknown';
}

const String sdkPackageVersion = "2.1.1";
