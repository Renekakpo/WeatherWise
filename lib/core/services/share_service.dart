import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share/share.dart';

/// Thin wrapper over share so feature code never imports a third-party
/// package directly. Will swap to share_plus in step 11.
class ShareService {
  const ShareService();

  Future<void> shareText(String text, {String? subject}) async {
    Share.share(text, subject: subject);
  }
}

final shareServiceProvider = Provider<ShareService>((_) {
  return const ShareService();
});
