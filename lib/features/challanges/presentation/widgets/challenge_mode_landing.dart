import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayssir/common/core/app_assets/dynamic_app_asset.dart';
import 'package:tayssir/resources/resources.dart';

// ════════════════════════════════════════════════
//  ChallengeModeLanding  –  Light / White mode
// ════════════════════════════════════════════════
class ChallengeModeLanding extends StatefulWidget {
  final VoidCallback onEnterMode;
  const ChallengeModeLanding({Key? key, required this.onEnterMode})
      : super(key: key);

  @override
  State<ChallengeModeLanding> createState() => _ChallengeModeLandingState();
}

class _ChallengeModeLandingState extends State<ChallengeModeLanding> {
  bool _pressing = false;

  void _onTapDown(_) => setState(() => _pressing = true);
  void _onTapUp(_) => setState(() => _pressing = false);
  void _onTapCancel() => setState(() => _pressing = false);

  Future<void> _handleEnter() async {
    HapticFeedback.heavyImpact();
    setState(() => _pressing = false);
    _showPortalOverlay(context, widget.onEnterMode);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0B1120) : const Color(0xFFF0F8FF),
        body: Stack(
          children: [
            // ── Background gradient ──
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? [
                            const Color(0xFF0F172A),
                            const Color(0xFF0B1120),
                            const Color(0xFF060914),
                          ]
                        : [
                            const Color(0xFFE4F4FD),
                            const Color(0xFFF2F9FF),
                            const Color(0xFFE8F5FF),
                          ],
                  ),
                ),
              ),
            ),

            // ── Blob top-left ──
            Positioned(
              top: -80.h,
              left: -80.w,
              child: Container(
                width: 260.w,
                height: 260.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00C6E0).withOpacity(0.13),
                ),
              ),
            ),
            Positioned(
              top: 40.h,
              left: -30.w,
              child: Container(
                width: 90.w,
                height: 90.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00C6E0).withOpacity(0.07),
                ),
              ),
            ),

            // ── Blob bottom-right ──
            Positioned(
              bottom: -60.h,
              right: -60.w,
              child: Container(
                width: 220.w,
                height: 220.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0083B0).withOpacity(0.10),
                ),
              ),
            ),
            Positioned(
              bottom: 160.h,
              right: 10.w,
              child: Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00C6E0).withOpacity(0.18),
                ),
              ),
            ),

            // ── Main Content ──
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back Button Alignment
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF00C6E0)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const Spacer(flex: 1),

                    // ── HERO CHARACTER ──
                    Container(
                      width: 220.w,
                      height: 220.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00C6E0).withOpacity(0.22),
                            blurRadius: 50,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const DynamicAppAsset(
                        assetKey: 'challenge_character',
                        fallbackAssetPath: SVGs.titoBoarding,
                        type: AppAssetType.svg,
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .moveY(
                            begin: 0,
                            end: -18,
                            duration: 2800.ms,
                            curve: Curves.easeInOut),

                    SizedBox(height: 28.h),

                    // ── Title ──
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'ساحة التحديات الكبرى',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 33.sp,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'SomarSans',
                            color: isDark ? Colors.white : const Color(0xFF0A2540),
                            letterSpacing: -0.5,
                            shadows: [
                              Shadow(
                                color: const Color(0xFF00AECC).withOpacity(0.3),
                                offset: const Offset(0, 4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.3, end: 0),

                    SizedBox(height: 20.h),

                    // ── Chips — mono-teal palette in a soft card ──
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 9.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C6E0).withOpacity(0.06),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: const Color(0xFF00C6E0).withOpacity(0.18),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _Chip('⚔️  نافس', const Color(0xFF0083B0)),
                          SizedBox(width: 6.w),
                          _Chip('🏆  تفوق', const Color(0xFF00AECC)),
                          SizedBox(width: 6.w),
                          _Chip('⚡  تشعّل', const Color(0xFF00C6E0)),
                        ],
                      ),
                    ).animate().fadeIn(delay: 300.ms, duration: 700.ms),

                    const Spacer(flex: 2),

                    // ── ENTER BUTTON ──
                    GestureDetector(
                      onTap: _handleEnter,
                      onTapDown: _onTapDown,
                      onTapUp: _onTapUp,
                      onTapCancel: _onTapCancel,
                      child: AnimatedScale(
                        scale: _pressing ? 0.95 : 1.0,
                        duration: const Duration(milliseconds: 110),
                        curve: Curves.easeOut,
                        child: Container(
                          width: double.infinity,
                          height: 68.h,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0083B0), Color(0xFF00C6E0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00C6E0).withOpacity(0.42),
                                blurRadius: 22,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Bottom 3-D edge
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.16),
                                    borderRadius: const BorderRadius.vertical(
                                        bottom: Radius.circular(28)),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.rocket_launch_rounded,
                                          color: Colors.white, size: 26)
                                      .animate(
                                          onPlay: (c) => c.repeat(reverse: true))
                                      .moveY(begin: 0, end: -4, duration: 800.ms),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'ادخل الساحة!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 21.sp,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'SomarSans',
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                      .animate(delay: 800.ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.3, end: 0),

                    // Add enough space for the bottom navigation bar
                    SizedBox(height: 120.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────
//  Chip widget
// ──────────────────────────────
class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final displayColor = isDark ? color.withOpacity(0.8) : color;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: displayColor.withOpacity(isDark ? 0.2 : 0.11),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: displayColor.withOpacity(0.35), width: 1.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDark ? Colors.white : color,
          fontSize: 13.sp,
          fontWeight: FontWeight.w800,
          fontFamily: 'SomarSans',
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
//  Portal Overlay  –  single AnimationController, smooth
// ══════════════════════════════════════════════════════
void _showPortalOverlay(BuildContext context, VoidCallback onComplete) {
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _PortalOverlay(
      onDone: () {
        onComplete();
        Future.delayed(const Duration(milliseconds: 350), () {
          if (entry.mounted) entry.remove();
        });
      },
    ),
  );
  Overlay.of(context, rootOverlay: true).insert(entry);
}

class _PortalOverlay extends StatefulWidget {
  final VoidCallback onDone;
  const _PortalOverlay({required this.onDone});
  @override
  State<_PortalOverlay> createState() => _PortalOverlayState();
}

class _PortalOverlayState extends State<_PortalOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  // All animations derived from one controller via Interval — no jank
  late Animation<double> _ring1;      // 0.00 → 0.55
  late Animation<double> _ring2;      // 0.10 → 0.60
  late Animation<double> _ring3;      // 0.20 → 0.68
  late Animation<double> _particles;  // 0.05 → 0.68
  late Animation<double> _fill;       // 0.52 → 1.00

  final Random _rnd = Random();
  late List<_Particle> _ptList;

  Animation<double> _iv(double b, double e, Curve c) => CurvedAnimation(
        parent: _ctrl,
        curve: Interval(b, e, curve: c),
      );

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );

    _ring1 = _iv(0.00, 0.55, Curves.easeOut);
    _ring2 = _iv(0.10, 0.60, Curves.easeOut);
    _ring3 = _iv(0.20, 0.68, Curves.easeOut);
    _particles = _iv(0.05, 0.68, Curves.easeOut);
    _fill = _iv(0.52, 1.00, Curves.easeInOut);

    // Teal-only particles — elegant & matching the page
    _ptList = List.generate(38, (_) {
      final angle = _rnd.nextDouble() * 2 * pi;
      final speed = 0.35 + _rnd.nextDouble() * 1.0;
      return _Particle(
        dx: cos(angle) * speed,
        dy: sin(angle) * speed,
        size: 2 + _rnd.nextDouble() * 8,
        color: Color.lerp(
          const Color(0xFF00D4F0),
          const Color(0xFF0063A8),
          _rnd.nextDouble(),
        )!,
        opacity: 0.5 + _rnd.nextDouble() * 0.5,
      );
    });

    _ctrl.forward().then((_) async {
      if (mounted) widget.onDone();
    });

    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 950), () {
      if (mounted) HapticFeedback.mediumImpact();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxR = size.longestSide * 1.25;

    return Material(
      type: MaterialType.transparency,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          final fillR = _fill.value * maxR;
          return Stack(
            children: [
              // ── Instant full-screen dark background (no flash) ──
              const Positioned.fill(
                child: ColoredBox(color: Color(0xFF0B1120)),
              ),

              // ── Three dark-mode ripple rings ──
              _ripple(size, _ring1.value, maxR * 0.50,
                  const Color(0xFF0B1120), 3.5),
              _ripple(size, _ring2.value, maxR * 0.68,
                  const Color(0xFF0D1830), 2.5),
              _ripple(size, _ring3.value, maxR * 0.85,
                  const Color(0xFF111827), 1.5),

              // ── Teal particles ──
              Positioned.fill(
                child: CustomPaint(
                  painter: _ParticlesPainter(
                    particles: _ptList,
                    progress: _particles.value,
                  ),
                ),
              ),

              // ── Dark portal filling screen — same bg as challenge dashboard ──
              if (_fill.value > 0)
                Positioned(
                  left: size.width / 2 - fillR,
                  top: size.height / 2 - fillR,
                  child: Container(
                    width: fillR * 2,
                    height: fillR * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF111827),
                          const Color(0xFF0B1120),
                          const Color(0xFF060C18),
                        ],
                        stops: const [0.0, 0.55, 1.0],
                        radius: 0.9,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _ripple(Size size, double progress, double maxRadius,
      Color color, double baseWidth) {
    if (progress <= 0) return const SizedBox.shrink();
    final r = progress * maxRadius;
    // Fast fade-in, gradual fade-out
    final opacity = (progress < 0.2
            ? progress / 0.2
            : 1 - (progress - 0.2) / 0.8)
        .clamp(0.0, 1.0);

    return Positioned(
      left: size.width / 2 - r,
      top: size.height / 2 - r,
      child: Container(
        width: r * 2,
        height: r * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Solid filled dark wave — no stroke, just filled ink
          color: color.withOpacity(opacity * 0.50),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(opacity * 0.25),
              blurRadius: 20,
              spreadRadius: 4,
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────
//  Particle model
// ──────────────────────────────
class _Particle {
  final double dx, dy, size, opacity;
  final Color color;
  const _Particle({
    required this.dx,
    required this.dy,
    required this.size,
    required this.color,
    required this.opacity,
  });
}

// ──────────────────────────────
//  Particle painter
// ──────────────────────────────
class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  const _ParticlesPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final cx = size.width / 2;
    final cy = size.height / 2;

    for (final p in particles) {
      final px = cx + p.dx * progress * size.width * 0.44;
      final py = cy + p.dy * progress * size.height * 0.44;
      // Fade out in last 35%
      final fade = progress < 0.65 ? 1.0 : 1 - (progress - 0.65) / 0.35;
      final alpha = (p.opacity * fade).clamp(0.0, 1.0);
      final r = p.size * (1 + progress * 0.5);

      // Soft glow halo
      canvas.drawCircle(
        Offset(px, py),
        r * 2.4,
        Paint()
          ..color = p.color.withOpacity(alpha * 0.22)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
      );
      // Crisp core dot
      canvas.drawCircle(
        Offset(px, py),
        r,
        Paint()..color = p.color.withOpacity(alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter old) =>
      old.progress != progress;
}
