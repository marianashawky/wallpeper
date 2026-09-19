import 'package:flutter/material.dart';

import '../../state/app_scope.dart';

class AdBannerSlot extends StatelessWidget {
  const AdBannerSlot({super.key});

  @override
  Widget build(BuildContext context) {
    return AppStateScope.of(context).ads.buildBanner();
  }
}
