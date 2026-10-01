import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:interactions/studies/feedback/face/face_pose.dart';

/// Two eyes and a mouth, filled, with no outline, pupil, or shine.
class FacePainter extends CustomPainter {
  const FacePainter({
    required this.mood,
    required this.color,
    required this.eyeOpen,
    required this.sheetWidth,
  });

  final double mood;
  final Color color;
  final double eyeOpen;
  final double sheetWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final pose = FacePose.compose(mood);
    final fit = _fit(pose, size);
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(4.5, sheetWidth * 0.018 * fit)
      ..strokeCap = StrokeCap.round;
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2 + pose.posture * sheetWidth * fit);
    _eye(canvas, pose, fit, paint, -1);
    _eye(canvas, pose, fit, paint, 1);
    _mouth(canvas, pose, fit, stroke);
    canvas.restore();
  }

  void _eye(Canvas canvas, FacePose pose, double fit, Paint paint, int side) {
    final w = pose.eyeW * sheetWidth * fit;
    final h = math.max(2.4, pose.eyeH * sheetWidth * fit * (0.07 + 0.93 * eyeOpen));
    final x = side * (w + pose.gap * sheetWidth * fit) / 2;
    final y = pose.eyeY * sheetWidth * fit;
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(side * pose.tilt);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: w, height: h),
        Radius.circular(math.min(w, h) / 2),
      ),
      paint,
    );
    canvas.restore();
  }

  void _mouth(Canvas canvas, FacePose pose, double fit, Paint paint) {
    final w = pose.mouthW * sheetWidth * fit;
    final y = pose.mouthY * sheetWidth * fit;
    final curve = pose.mouthCurve * sheetWidth * fit;
    final path = Path()
      ..moveTo(-w / 2, y)
      ..quadraticBezierTo(0, y + curve, w / 2, y);
    canvas.drawPath(path, paint);
  }

  double _fit(FacePose pose, Size size) {
    final eye = math.max(pose.eyeW, pose.eyeH) * sheetWidth;
    final span = (pose.eyeW + pose.gap) * sheetWidth;
    final drop = (pose.mouthY + pose.mouthCurve.abs() + pose.posture.abs() + 0.03) * sheetWidth;
    final needed = eye * 0.65 + drop;
    var fit = 1.0;
    if (needed > size.height * 0.92 && needed > 1) fit = size.height * 0.92 / needed;
    if (span > size.width * 0.92 && span > 1) fit = math.min(fit, size.width * 0.92 / span);
    return fit.clamp(0.45, 1.0);
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) =>
      oldDelegate.mood != mood ||
      oldDelegate.color != color ||
      oldDelegate.eyeOpen != eyeOpen ||
      oldDelegate.sheetWidth != sheetWidth;
}
