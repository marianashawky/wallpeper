import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final padding = AppSpacing.page(MediaQuery.sizeOf(context).width);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(padding, AppSpacing.md, padding, AppSpacing.xl),
        children: [
          Text(body, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.45)),
        ],
      ),
    );
  }
}
