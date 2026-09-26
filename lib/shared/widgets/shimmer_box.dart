import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class ShimmerScope extends StatefulWidget {
  const ShimmerScope({super.key, required this.child});

  final Widget child;

  static Animation<double>? maybeOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ShimmerData>();
    return scope?.animation;
  }

  @override
  State<ShimmerScope> createState() => _ShimmerScopeState();
}

class _ShimmerScopeState extends State<ShimmerScope> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ShimmerData(animation: _controller, child: widget.child);
  }
}

class _ShimmerData extends InheritedWidget {
  const _ShimmerData({required this.animation, required super.child});

  final Animation<double> animation;

  @override
  bool updateShouldNotify(_ShimmerData oldWidget) => false;
}

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({super.key});

  @override
  Widget build(BuildContext context) {
    final animation = ShimmerScope.maybeOf(context);
    final base = Theme.of(context).brightness == Brightness.dark ? AppColors.card : AppColors.lightChip;
    final highlight = Theme.of(context).brightness == Brightness.dark ? AppColors.cardRaised : Colors.white;
    if (animation == null) return ColoredBox(color: base);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final t = animation.value;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.4 + (t * 2.8), 0),
              end: Alignment(-0.2 + (t * 2.8), 0),
              colors: [base, highlight, base],
            ),
          ),
        );
      },
    );
  }
}
