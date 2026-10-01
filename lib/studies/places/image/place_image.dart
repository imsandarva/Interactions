import 'package:flutter/widgets.dart';

/// One decoded size for the card and the hero, so the flight never swaps resolution.
int placeCacheWidth(BuildContext context) {
  final px =
      MediaQuery.sizeOf(context).width * MediaQuery.devicePixelRatioOf(context);
  return px.clamp(720, 1440).round();
}

/// The photograph, with its tone behind it so a late decode never flashes white.
class PlaceImage extends StatelessWidget {
  const PlaceImage({
    required this.asset,
    required this.focal,
    required this.tone,
    this.reveal = 1,
    super.key,
  });

  final String asset;
  final Alignment focal;
  final Color tone;
  final double reveal;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: tone,
      child: Opacity(
        opacity: reveal.clamp(0.0, 1.0),
        child: Image(
          image: ResizeImage(
            AssetImage(asset),
            width: placeCacheWidth(context),
          ),
          fit: BoxFit.cover,
          alignment: focal,
          gaplessPlayback: true,
          filterQuality: FilterQuality.medium,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, _, _) => const SizedBox.expand(),
        ),
      ),
    );
  }
}

/// A photo slightly larger than its frame, shifted inside it, edges never showing.
class ShiftedPhoto extends StatelessWidget {
  const ShiftedPhoto({
    required this.height,
    required this.shift,
    required this.extra,
    required this.child,
    super.key,
  });

  final double height;
  final double shift;
  final double extra;
  final Widget child;

  /// The shift actually applied, so an overlay can move with the photograph.
  static double appliedShift(double shift, double extra, double height) {
    final room = extra.clamp(0.0, height);
    return shift.clamp(-room / 2, room / 2);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final room = extra.clamp(0.0, height);
        final dy = appliedShift(shift, extra, height);
        return ClipRect(
          child: SizedBox(
            height: height,
            width: width,
            child: OverflowBox(
              alignment: Alignment.center,
              minWidth: width,
              maxWidth: width,
              minHeight: height + room,
              maxHeight: height + room,
              child: Transform.translate(
                offset: Offset(0, dy),
                child: SizedBox(
                  width: width,
                  height: height + room,
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
