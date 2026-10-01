import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:interactions/studies/places/copy/places.dart';
import 'package:interactions/studies/places/image/place_image.dart';
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
    required this.onOpen,
    super.key,
  });

  final Place place;
  final GlobalKey frameKey;
  final GlobalKey imageKey;
  final FocusNode focusNode;
  final ValueNotifier<int?> hidden;
  final VoidCallback onOpen;

  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  var _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    return ValueListenableBuilder<int?>(
      valueListenable: widget.hidden,
      builder: (context, hiddenId, child) {
        final gone = hiddenId == place.id;
        return IgnorePointer(
          ignoring: gone,
          child: ExcludeSemantics(
            excluding: gone,
            child: Opacity(opacity: gone ? 0 : 1, child: child),
          ),
        );
      },
      child: _Frame(
        key: widget.frameKey,
        child: Focus(
          focusNode: widget.focusNode,
          child: Semantics(
            button: true,
            label: place.label,
            child: GestureDetector(
              key: ValueKey('place-card-${place.id}'),
              behavior: HitTestBehavior.opaque,
              onTapDown: (_) {
                _setPressed(true);
                HapticFeedback.lightImpact();
              },
              onTapUp: (_) => _setPressed(false),
              onTapCancel: () => _setPressed(false),
              onTap: widget.onOpen,
              child: AnimatedScale(
                scale: _pressed ? PlacesSpec.pressScale : 1,
                duration: const Duration(milliseconds: 120),
                curve: Curves.easeOut,
                child: _CardFace(place: place, imageKey: widget.imageKey),
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
  const _CardFace({required this.place, required this.imageKey});

  final Place place;
  final GlobalKey imageKey;

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
                child: PlaceImage(place: place),
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
