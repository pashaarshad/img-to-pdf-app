import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class BrandLogo extends StatelessWidget {
  final double size;
  final bool showBadge;

  const BrandLogo({
    super.key,
    this.size = 56,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(size * 0.22),
        border: Border.all(
          color: AppTheme.borderGrey,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.65,
          height: size * 0.72,
          child: CustomPaint(
            painter: _PdfDocumentIconPainter(
              accentColor: AppTheme.primaryRed,
              foldColor: AppTheme.primaryRedDark,
            ),
          ),
        ),
      ),
    );
  }
}

class _PdfDocumentIconPainter extends CustomPainter {
  final Color accentColor;
  final Color foldColor;

  _PdfDocumentIconPainter({
    required this.accentColor,
    required this.foldColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double corner = w * 0.32;

    // Body path with top-right fold cut
    final bodyPath = Path()
      ..moveTo(0, h * 0.08)
      ..arcToPoint(Offset(w * 0.08, 0), radius: Radius.circular(w * 0.08))
      ..lineTo(w - corner, 0)
      ..lineTo(w, corner)
      ..lineTo(w, h * 0.92)
      ..arcToPoint(Offset(w * 0.92, h), radius: Radius.circular(w * 0.08))
      ..lineTo(w * 0.08, h)
      ..arcToPoint(Offset(0, h * 0.92), radius: Radius.circular(w * 0.08))
      ..close();

    final bodyPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(bodyPath, bodyPaint);

    // Folded top-right ear
    final earPath = Path()
      ..moveTo(w - corner, 0)
      ..lineTo(w - corner, corner)
      ..lineTo(w, corner)
      ..close();

    final earPaint = Paint()
      ..color = foldColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(earPath, earPaint);

    // "PDF" label in the center
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'PDF',
        style: TextStyle(
          color: Colors.white,
          fontSize: h * 0.28,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((w - textPainter.width) / 2, h * 0.44),
    );

    // Document lines at the bottom
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..strokeWidth = h * 0.04
      ..strokeCap = StrokeCap.round;

    final lineY1 = h * 0.80;
    canvas.drawLine(
      Offset(w * 0.22, lineY1),
      Offset(w * 0.78, lineY1),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TrustBadgesRow extends StatelessWidget {
  const TrustBadgesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          _BadgeItem(icon: Icons.check_circle_outline, label: '100% Free'),
          SizedBox(width: 8),
          _BadgeItem(icon: Icons.block, label: 'No Ads'),
          SizedBox(width: 8),
          _BadgeItem(icon: Icons.wifi_off_rounded, label: '100% Offline'),
          SizedBox(width: 8),
          _BadgeItem(icon: Icons.code_rounded, label: 'Open Source'),
        ],
      ),
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BadgeItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.surfaceGrey,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.borderGrey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppTheme.primaryRed),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMain,
            ),
          ),
        ],
      ),
    );
  }
}
