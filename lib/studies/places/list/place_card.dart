import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:interactions/studies/places/copy/places.dart';
import 'package:interactions/studies/places/image/place_image.dart';
import 'package:interactions/studies/places/list/saved_mark.dart';
import 'package:interactions/studies/places/memory/place_memory.dart';
import 'package:interactions/studies/places/motion/places_spec.dart';
import 'package:interactions/studies/places/theme/places_style.dart';

/// The resting card. Its frame is what the page must land back on.
class PlaceCard extends StatefulWidget {
  const PlaceCard({
    required this.place,
    required this.frameKey,
    required this.imageKey,
    required this.focusNode,
    required this.hidden,
    required this.scroll,
    required this.appear,
    required this.photoAppear,
    required this.onOpen,
    super.key,
  });

  final Place place;
  final GlobalKey frameKey;
  final GlobalKey imageKey;
  final FocusNode focusNode;
  final ValueNotifier<int?> hidden;
  final ValueNotifier<double> scroll;
  final double appear;
  final double photoAppear;
  final void Function(double photoShift) onOpen;

  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard>
    with SingleTickerProviderStateMixin {
  var _pressed = false;
  late final AnimationController _mark = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
    reverseDuration: const Duration(milliseconds: 200),
  );
  PlaceMemory get _memory => PlaceMemory.instance;

  @override
  void initState() {
    super.initState();
    _mark.value = _memory.isSaved(widget.place.id) ? 1 : 0;
    _memory.addListener(_onMemory);
  }

  @override
  void dispose() {
    _memory.removeListener(_onMemory);
    _mark.dispose();
    super.dispose();
  }

  void _onMemory() {
    if (!mounted) return;
    if (_memory.cueId == widget.place.id) {
      final show = _memory.isSaved(widget.place.id);
      _memory.clearCue();
      if (MediaQuery.disableAnimationsOf(context)) {
        _mark.value = show ? 1 : 0;
      } else {
        show ? _mark.forward() : _mark.reverse();
      }
    }
    setState(() {});
  }

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  double _photoShift() {
    final box =
        widget.imageKey.currentContext?.findRenderObject() as RenderBox?;
    final scrollable = Scrollable.maybeOf(context);
    final viewport = scrollable?.context.findRenderObject() as RenderBox?;
    if (box == null || viewport == null || !box.hasSize || !box.attached) {
      return 0;
    }
    final top = box.localToGlobal(Offset.zero, ancestor: viewport).dy;
    final max = box.size.height * 0.08;
    if (MediaQuery.disableAnimationsOf(context)) return 0;
    return (-top * PlacesSpec.cardParallax).clamp(-max, max);
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    final saved = _memory.isSaved(place.id);
    return ValueListenableBuilder<int?>(
      valueListenable: widget.hidden,
      builder: (context, hiddenId, child) {
        final gone = hiddenId == place.id;
        return IgnorePointer(
          ignoring: gone,
          child: ExcludeSemantics(
            excluding: gone,
            child: Opacity(opacity: gone ? 0 : widget.appear, child: child),
          ),
        );
      },
      child: Transform.translate(
        offset: Offset(0, (1 - widget.appear) * 24),
        child: _Frame(
          key: widget.frameKey,
          child: Focus(
            focusNode: widget.focusNode,
            child: Semantics(
              button: true,
              label: saved ? '${place.label}, saved' : place.label,
              child: GestureDetector(
                key: ValueKey('place-card-${place.id}'),
                behavior: HitTestBehavior.opaque,
                onTapDown: (_) {
                  _setPressed(true);
                  HapticFeedback.lightImpact();
                },
                onTapUp: (_) => _setPressed(false),
                onTapCancel: () => _setPressed(false),
                onTap: () => widget.onOpen(_photoShift()),
                child: AnimatedScale(
                  scale: _pressed ? PlacesSpec.pressScale : 1,
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOut,
                  child: _CardFace(
                    place: place,
                    imageKey: widget.imageKey,
                    scroll: widget.scroll,
                    photoAppear: widget.photoAppear,
                    shiftOf: _photoShift,
                    mark: _mark,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Layout size stays put while the press scale only paints smaller.
class _Frame extends SingleChildRenderObjectWidget {
  const _Frame({required super.child, super.key});

  @override
  RenderProxyBox createRenderObject(BuildContext context) => RenderProxyBox();
}

class _CardFace extends StatelessWidget {
  const _CardFace({
    required this.place,
    required this.imageKey,
    required this.scroll,
    required this.photoAppear,
    required this.shiftOf,
    required this.mark,
  });

  final Place place;
  final GlobalKey imageKey;
  final ValueNotifier<double> scroll;
  final double photoAppear;
  final double Function() shiftOf;
  final Animation<double> mark;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: PlacesColors.surface,
        borderRadius: BorderRadius.all(Radius.circular(PlacesSpec.cardRadius)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(PlacesSpec.cardRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1 / PlacesSpec.imageTall,
              child: SizedBox(
                key: imageKey,
                child: ValueListenableBuilder<double>(
                  valueListenable: scroll,
                  builder: (context, _, _) {
                    final photo = place.photoAt(
                      PlaceMemory.instance.photoOf(place.id),
                    );
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final h = constraints.maxHeight;
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            ShiftedPhoto(
                              height: h,
                              shift: shiftOf(),
                              extra: h * 0.16,
                              child: PlaceImage(
                                asset: photo.asset,
                                focal: photo.focal,
                                tone: place.tone.tone,
                                reveal: photoAppear,
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: AnimatedBuilder(
                                animation: mark,
                                builder: (_, _) => SavedMark(
                                  key: ValueKey('place-mark-${place.id}'),
                                  t: mark.value,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                PlacesSpec.padCard,
                16,
                PlacesSpec.padCard,
                16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.title,
                    style: PlacesType.title(PlacesSpec.titleCard),
                  ),
                  const SizedBox(height: 4),
                  Text(place.meta, style: PlacesType.meta),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
