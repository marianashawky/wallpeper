import 'package:flutter/widgets.dart';

class AdService {
  Future<void> initialize() async {}

  Widget buildBanner() => const SizedBox.shrink();

  Future<void> maybeShowInterstitial() async {}

  Future<bool> showRewarded() async => false;
}
