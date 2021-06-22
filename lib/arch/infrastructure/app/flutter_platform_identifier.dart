import 'dart:io';

import 'package:hukum_pro/arch/infrastructure/app/platform_identifier.dart';

class FlutterPlatformIdentifier implements PlatformIdentifier {
  @override
  bool get isAndroid => Platform.isAndroid;

  @override
  bool get isFuchsia => Platform.isFuchsia;

  @override
  bool get isIOS => Platform.isIOS;

  @override
  bool get isLinux => Platform.isLinux;

  @override
  bool get isMacOS => Platform.isMacOS;

  @override
  bool get isWindows => Platform.isWindows;
}
