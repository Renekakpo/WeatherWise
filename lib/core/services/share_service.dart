import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

/// Thin wrapper over share_plus so feature code never imports a third-party
/// package directly.
class ShareService {
  const ShareService();

  Future<void> shareText(String text, {String? subject}) async {
    await Share.share(text, subject: subject);
  }
}

final shareServiceProvider = Provider<ShareService>((_) {
  return const ShareService();
});
