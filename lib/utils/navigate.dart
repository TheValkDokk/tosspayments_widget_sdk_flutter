import 'dart:io';

import 'package:flutter/material.dart';

Future<dynamic> navigateToWebviewByPlatform(BuildContext context, Widget page) async {
  return await showModalBottomSheet(
    context: context,
    builder: (context) => page,
    isScrollControlled: true,
    isDismissible: Platform.isIOS,
    enableDrag: Platform.isIOS,
    useSafeArea: true,
  );
}
