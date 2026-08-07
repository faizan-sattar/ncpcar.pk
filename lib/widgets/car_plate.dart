import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable "car photo" stand-in: a duotone plate with a faint diagonal
/// blueprint hatch and a stylised side-profile car glyph, so listings read as
/// an intentional illustrative system rather than a broken image.
class CarPlate extends StatelessWidget {
  final Color plateA;
  final Color plateB;
  final Color glyphColor;
  final BorderRadius? radius;
  final bool verified;
  final String? photoCount;
  final bool showFav;
  final bool isFav;
  final VoidCallback? onFavToggle;

  const CarPlate({
    super.key,
    required this.plateA,
    required this.plateB,
    required this.glyphColor,
    this.radius,
    this.verified = false,
    this.photoCount,
    this.showFav = false,
    this.isFav = false,
    this.onFavToggle,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ClipRRect(
      borderRadius: radius ?? BorderRadius.circular(AppRadius.md),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [plateA, plateB],
              ),
            ),
          ),
          CustomPaint(painter: _HatchPainter(color: Colors.black.withValues(alpha: 0.035))),
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.6,
              child: CustomPaint(painter: _CarPainter(color: glyphColor), child: const AspectRatio(aspectRatio: 124 / 56)),
            ),
          ),
          if (verified)
            Positioned(
              top: 8,
              left: 8,
              child: _MiniBadge(
                icon: Icons.check_rounded,
                label: 'Verified',
                bg: c.verifiedBg,
                fg: c.verified,
              ),
            ),
          if (photoCount != null)
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(photoCount!, style: bodyStyle(size: 10.5, weight: 700, color: Colors.white)),
              ),
            ),
          if (showFav)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onFavToggle,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.88),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    size: 15,
                    color: isFav ? c.red : c.ink,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;
  const _MiniBadge({required this.icon, required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 3, 8, 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: fg),
          const SizedBox(width: 3),
          Text(label, style: bodyStyle(size: 10.5, weight: 800, color: fg)),
        ],
      ),
    );
  }
}

class _HatchPainter extends CustomPainter {
  final Color color;
  const _HatchPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const gap = 14.0;
    final diag = size.width + size.height;
    for (double x = -diag; x < diag; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HatchPainter oldDelegate) => oldDelegate.color != color;
}

/// Side-profile car pictogram, drawn in a fixed 124x56 reference space and
/// scaled to the paint size — reused across every listing plate for a
/// consistent illustrative identity.
class _CarPainter extends CustomPainter {
  final Color color;
  const _CarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 124;
    final sy = size.height / 56;
    canvas.save();
    canvas.scale(sx, sy);

    final body = Path()
      ..moveTo(8, 40)
      ..lineTo(16, 40)
      ..cubicTo(16, 31, 23, 24, 32, 24)
      ..lineTo(45, 24)
      ..cubicTo(50, 15, 59, 10, 70, 10)
      ..lineTo(86, 10)
      ..cubicTo(95, 10, 102, 15, 106, 24)
      ..lineTo(112, 24)
      ..cubicTo(116, 24, 118, 27, 118, 31)
      ..lineTo(118, 40)
      ..close();
    canvas.drawPath(body, Paint()..color = color);

    final hub = Paint()..color = color.computeLuminance() > 0.5 ? Colors.black87 : Colors.black.withValues(alpha: 0.85);
    final inner = Paint()..color = Colors.white.withValues(alpha: 0.75);
    for (final cx in [34.0, 96.0]) {
      canvas.drawCircle(Offset(cx, 41), 9, hub);
      canvas.drawCircle(Offset(cx, 41), 3.6, inner);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CarPainter oldDelegate) => oldDelegate.color != color;
}

/// A small deterministic palette so demo listings feel varied without
/// depending on real photography.
class PlateStyle {
  final Color a, b, glyph;
  const PlateStyle(this.a, this.b, this.glyph);
}

const platePalette = [
  PlateStyle(Color(0xFFF4E6D8), Color(0xFFE0CBAE), Color(0xFF8A6A45)),
  PlateStyle(Color(0xFFE4E9EC), Color(0xFFC7D0D6), Color(0xFF57707D)),
  PlateStyle(Color(0xFFEFE2E2), Color(0xFFD8BEC0), Color(0xFF8A4D4D)),
  PlateStyle(Color(0xFFE6EAD9), Color(0xFFCBD3B4), Color(0xFF606B45)),
  PlateStyle(Color(0xFFE8E2EC), Color(0xFFC9BEDA), Color(0xFF5C4D75)),
  PlateStyle(Color(0xFFE9E4DC), Color(0xFFD2C7B6), Color(0xFF6B5C47)),
];

PlateStyle plateFor(int index) => platePalette[index % platePalette.length];
