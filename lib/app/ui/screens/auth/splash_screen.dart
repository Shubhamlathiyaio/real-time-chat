import 'package:flutter/material.dart';
import 'package:real_time_chat/app/controllers/app_controller.dart';
import 'package:real_time_chat/app/utils/helpers/extensions/context.dart';
import 'package:real_time_chat/app/utils/helpers/injectable/injectable.dart';
import 'package:real_time_chat/app/utils/theme/app_colors.dart';
import 'package:real_time_chat/app/utils/theme/app_system_ui_overlay_style.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // --- Animation Controllers ---
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _dotsController;
  late final AnimationController _bgController;

  // --- Logo Animations ---
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  // --- Text Animations ---
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;

  // --- Subtitle Animations ---
  late final Animation<double> _subtitleOpacity;

  // --- Background shimmer ---
  late final Animation<double> _bgAnim;

  @override
  void initState() {
    super.initState();

    // Logo: scale + fade in
    _logoController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _logoScale = CurvedAnimation(parent: _logoController, curve: Curves.elasticOut);
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _logoController, curve: const Interval(0, 0.4)));

    // Text: slide up + fade in (delayed)
    _textController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _textOpacity = CurvedAnimation(parent: _textController, curve: Curves.easeIn);
    _subtitleOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _textController, curve: const Interval(0.4, 1)));

    // Dots loading indicator
    _dotsController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();

    // Background shimmer
    _bgController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _bgAnim = CurvedAnimation(parent: _bgController, curve: Curves.easeInOut);

    // Sequence: logo first, then text
    _logoController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) _textController.forward();
      });
    });

    // Navigate after delay
    getIt<AppController>().onSplash(context);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _dotsController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SplashSystemUiOverlayStyle(
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _bgAnim,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [Color.lerp(KColors.splashBgStart, KColors.splashBgEnd, _bgAnim.value)!, Color.lerp(KColors.splashBgEnd, KColors.splashBgAlt, _bgAnim.value)!]
                      : [Color.lerp(KColors.splashBgLightStart, KColors.splashBgLightMid, _bgAnim.value)!, Color.lerp(KColors.splashBgLightEnd, KColors.splashBgLightStart, _bgAnim.value)!],
                ),
              ),
              child: child,
            );
          },
          child: SafeArea(
            child: Stack(
              children: [
                // --- Decorative background blobs ---
                Positioned(top: -80, right: -60, child: _Blob(size: 260, color: theme.colorScheme.primary.changeOpacity(0.08))),
                Positioned(bottom: -100, left: -80, child: _Blob(size: 300, color: theme.colorScheme.primary.changeOpacity(0.06))),

                // --- Main content ---
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      ScaleTransition(
                        scale: _logoScale,
                        child: FadeTransition(
                          opacity: _logoOpacity,
                          child: _LogoBadge(theme: theme),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // App name
                      FadeTransition(
                        opacity: _textOpacity,
                        child: SlideTransition(
                          position: _textSlide,
                          child: Column(
                            children: [
                              Text(
                                'Real Time Chat',
                                style: theme.textTheme.h1.copyWith(fontSize: 36, fontWeight: .w800, letterSpacing: -1.2, color: theme.colorScheme.foreground),
                              ),
                              const SizedBox(height: 8),
                              FadeTransition(
                                opacity: _subtitleOpacity,
                                child: Text('Built with ♥ using Flutter', style: theme.textTheme.muted.copyWith(fontSize: 14, letterSpacing: 0.2)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- Loading dots at bottom ---
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: _textOpacity,
                    child: Center(child: _AnimatedDots(controller: _dotsController)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Logo Badge Widget
// ─────────────────────────────────────────────
class _LogoBadge extends StatelessWidget {
  const _LogoBadge({required this.theme});
  final ShadThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: theme.colorScheme.primary,
        boxShadow: [BoxShadow(color: theme.colorScheme.primary.changeOpacity(0.35), blurRadius: 32, spreadRadius: 4, offset: const Offset(0, 8))],
      ),
      child: Center(
        child: Image.asset('assets/images/splash_logo.png', width: 52, height: 52),
        // Icon(
        //   Icons.bolt_rounded, // 🔁 Replace with your own logo/icon
        //   size: 52,
        //   color: theme.colorScheme.primaryForeground,
        // ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Animated Loading Dots
// ─────────────────────────────────────────────
class _AnimatedDots extends StatelessWidget {
  const _AnimatedDots({required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final t = ((controller.value - delay) % 1.0).clamp(0.0, 1.0);
            final opacity = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.2, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 7,
              height: 7,
              decoration: BoxDecoration(shape: BoxShape.circle, color: theme.colorScheme.primary.changeOpacity(opacity)),
            );
          }),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Background Blob Decoration
// ─────────────────────────────────────────────
class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
