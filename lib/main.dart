import 'package:flutter/widgets.dart';

import 'package:interactions/app/interactions_app.dart';
import 'package:interactions/app/system/system_chrome.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  applySystemChrome();
  runApp(const InteractionsApp());
}
