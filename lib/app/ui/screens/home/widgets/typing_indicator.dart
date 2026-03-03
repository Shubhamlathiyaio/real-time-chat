import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with TickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final delay = i / 3;
          final t = ((_ctrl.value - delay) % 1.0).clamp(0.0, 1.0);
          final scale = 0.6 + 0.4 * (t < 0.5 ? t * 2 : (1 - t) * 2);
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            width: 5 * scale,
            height: 5 * scale,
            decoration: const BoxDecoration(color: Color(0xFF6366F1), shape: BoxShape.circle),
          );
        }),
      ),
    );
  }
}
