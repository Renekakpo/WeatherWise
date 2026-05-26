import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

Future<String?> myLoadAsset(String path, {AssetBundle? assetBundle}) async {
  try {
    final bundle = assetBundle ?? rootBundle;
    final exists = await bundle
        .load(path)
        .then((_) => true)
        .catchError((_) => false);
    return exists ? path : null;
  } catch (e) {
    if (kDebugMode) debugPrint('myLoadAsset error: $e');
    return null;
  }
}
