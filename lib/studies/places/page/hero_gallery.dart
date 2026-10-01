import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:interactions/studies/places/copy/places.dart';
import 'package:interactions/studies/places/image/place_image.dart';
import 'package:interactions/studies/places/memory/place_memory.dart';
import 'package:interactions/studies/places/page/photo_indicator.dart';

/// Three photographs. Horizontal movement pages them; vertical movement does not.
class HeroGallery extends StatefulWidget {
  const HeroGallery({
    required this.place,
    required this.photoHeight,
    required this.shift,
    required this.extra,
    required this.indicatorBottom,
    required this.interactive,
    required this.reduced,
    required this.indicator,
    super.key,
  });

  final Place place;
  final double photoHeight;
  final double shift;
  final double extra;

  /// Distance from the photograph's bottom edge up to the marks.
  final double indicatorBottom;
  final bool interactive;
  final bool reduced;
  final double indicator;

  @override
  State<HeroGallery> createState() => _HeroGalleryState();
}

class _HeroGalleryState extends State<HeroGallery> {
  PageController? _pages;
  var _index = 0;

  PlaceMemory get _memory => PlaceMemory.instance;

  @override
  void initState() {
    super.initState();
    _index = _memory.photoOf(widget.place.id);
    _pages = PageController(initialPage: _index);
  }

  @override
  void didUpdateWidget(HeroGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = _memory.photoOf(widget.place.id);
    if (next != _index) _index = next;
  }

  @override
  void dispose() {
    _pages?.dispose();
    super.dispose();
  }

  void _go(int index) {
    final last = widget.place.photos.length - 1;
    final next = index.clamp(0, last);
    if (next == _index) return;
    if (widget.reduced) {
      setState(() => _index = next);
      _remember(next);
      return;
    }
    _pages?.animateToPage(
      next,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _remember(int index) {
    if (index == _index) return;
    _index = index;
    _memory.setPhoto(widget.place.id, index);
    HapticFeedback.lightImpact();
  }

  void _tap(TapUpDetails details, double width) {
    if (!widget.interactive || width <= 0) return;
    final x = details.localPosition.dx;
    if (x < width / 3) _go(_index - 1);
    if (x > width * 2 / 3) _go(_index + 1);
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    final photo = place.photos[_index.clamp(0, place.photos.length - 1)];
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final dy = ShiftedPhoto.appliedShift(
          widget.shift,
          widget.extra,
          widget.photoHeight,
        );
        final frame = ShiftedPhoto(
          height: widget.photoHeight,
          shift: widget.shift,
          extra: widget.extra,
          child: widget.interactive && !widget.reduced
              ? _Pager(pages: _pages!, place: place, onChanged: _remember)
              : PlaceImage(
                  asset: photo.asset,
                  focal: photo.focal,
                  tone: place.tone.tone,
                ),
        );
        return Semantics(
          label: 'Photo ${_index + 1} of ${place.photos.length}',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (details) => _tap(details, width),
            child: SizedBox(
              height: widget.photoHeight,
              width: width,
              child: ClipRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    frame,
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: widget.indicatorBottom,
                      child: IgnorePointer(
                        child: Transform.translate(
                          offset: Offset(0, dy),
                          child: Opacity(
                            opacity: widget.indicator.clamp(0.0, 1.0),
                            child: PhotoIndicator(
                              count: place.photos.length,
                              index: _index,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Pager extends StatelessWidget {
  const _Pager({
    required this.pages,
    required this.place,
    required this.onChanged,
  });

  final PageController pages;
  final Place place;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pages,
      itemCount: place.photos.length,
      onPageChanged: onChanged,
      itemBuilder: (context, index) {
        final photo = place.photos[index];
        return LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedBuilder(
              animation: pages,
              builder: (context, child) {
                final page = pages.hasClients
                    ? (pages.page ?? pages.initialPage.toDouble())
                    : index.toDouble();
                // The frame slides fully; the photo lags by about a fifth.
                final dx = (index - page) * constraints.maxWidth * 0.2;
                return Transform.translate(offset: Offset(dx, 0), child: child);
              },
              child: PlaceImage(
                asset: photo.asset,
                focal: photo.focal,
                tone: place.tone.tone,
              ),
            );
          },
        );
      },
    );
  }
}
