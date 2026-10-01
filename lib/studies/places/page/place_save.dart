import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:interactions/studies/places/motion/places_spec.dart';
import 'package:interactions/studies/places/theme/places_style.dart';

/// Press only. Nothing is saved.
class PlaceSave extends StatefulWidget {
  const PlaceSave({super.key});

  @override
  State<PlaceSave> createState() => _PlaceSaveState();
}

class _PlaceSaveState extends State<PlaceSave> {
  var _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Save this place',
      child: GestureDetector(
        key: const Key('place-save'),
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {
          _setPressed(true);
          HapticFeedback.lightImpact();
        },
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: AnimatedScale(
          scale: _pressed ? PlacesSpec.pressScale : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _pressed ? PlacesColors.inkPressed : PlacesColors.ink,
              borderRadius: const BorderRadius.all(Radius.circular(28)),
            ),
            child: const SizedBox(
              height: 56,
              width: double.infinity,
              child: Center(
                child: Text('Save this place', style: PlacesType.save),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
