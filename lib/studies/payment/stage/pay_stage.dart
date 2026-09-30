import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:interactions/studies/payment/motion/morph_scene.dart';
import 'package:interactions/studies/payment/motion/pay_frame.dart';
import 'package:interactions/studies/payment/motion/pay_morph.dart';
import 'package:interactions/studies/payment/motion/pay_timing.dart';
import 'package:interactions/studies/payment/sheet/reveal.dart';
import 'package:interactions/studies/payment/sheet/sheet_body.dart';
import 'package:interactions/studies/payment/stage/studio_page.dart';
import 'package:interactions/studies/payment/theme/pay_style.dart';

/// Backdrop plus the one surface that is either the pill or the sheet.
class PayStage extends StatefulWidget {
  const PayStage({required this.morph, super.key});

  final PayMorph morph;

  @override
  State<PayStage> createState() => _PayStageState();
}

class _PayStageState extends State<PayStage> {
  final _scroll = ScrollController();
  var _pressed = false;
  var _drag = false;
  var _intrinsic = 0.0;
  var _scale = 1.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scale = MediaQuery.textScalerOf(context).scale(1);
    if (scale == _scale) return;
    _scale = scale;
    _intrinsic = 0;
  }

  void _remember(double height) {
    if (height < 1 || (height - _intrinsic).abs() < 1) return;
    setState(() => _intrinsic = height);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  void _onDrag(DragUpdateDetails details, double travel) {
    if (!_drag) return;
    final dy = details.delta.dy;
    final morph = widget.morph;
    final open = morph.t > 0.98 && morph.stretch <= 0.5;
    final canScroll = _scroll.hasClients && _scroll.position.maxScrollExtent > 1;
    final atTop = !_scroll.hasClients || _scroll.position.pixels <= 0;
    if (canScroll && open && !(atTop && dy > 0)) {
      final position = _scroll.position;
      position.jumpTo((position.pixels - dy).clamp(0.0, position.maxScrollExtent));
      return;
    }
    morph.dragBy(dy, travel);
  }

  void _endDrag(double vy, double travel) {
    if (!_drag) return;
    _drag = false;
    widget.morph.endDrag(vy, travel);
  }

  @override
  Widget build(BuildContext context) {
    final frame = PayFrame.of(MediaQuery.of(context)).sized(_intrinsic);
    final sheet = _intrinsic == 0
        ? _Measure(
            onHeight: _remember,
            child: SheetBody(scroll: _scroll, onClose: widget.morph.close),
          )
        : SheetBody(scroll: _scroll, onClose: widget.morph.close, fill: frame.openHeight);
    return AnimatedBuilder(
      animation: widget.morph,
      builder: (context, child) {
        if (widget.morph.reduced) return _crossfade(frame, child!);
        return _morph(MorphScene.morph(widget.morph.t, frame), frame, child!);
      },
      child: sheet,
    );
  }

  Widget _morph(MorphScene scene, FrameMetrics frame, Widget sheet) {
    final pressed = _pressed && scene.t < 0.2;
    return ColoredBox(
      color: PayColors.recess,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Transform.scale(
            scale: scene.backdropScale,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(scene.backdropRadius),
              child: const RepaintBoundary(child: StudioPage()),
            ),
          ),
          Positioned.fill(child: _dim(scene.t, scene.backdropDim)),
          Positioned(
            left: scene.marginH,
            right: scene.marginH,
            bottom: scene.marginBottom,
            height: scene.height,
            child: Transform.translate(
              offset: Offset(0, -widget.morph.stretch),
              child: Transform.scale(
                scale: pressed ? PayTiming.pressScale : 1,
                alignment: Alignment.bottomCenter,
                child: _surface(scene, frame, sheet),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _surface(MorphScene scene, FrameMetrics frame, Widget sheet) {
    final morph = widget.morph;
    final color = _pressed && scene.t < 0.05 ? PayColors.inkPressed : scene.surface;
    return GestureDetector(
      key: const Key('pay-surface'),
      behavior: HitTestBehavior.opaque,
      onTapDown: scene.t < 0.12
          ? (_) {
              _setPressed(true);
              HapticFeedback.lightImpact();
            }
          : null,
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: () {
        if (morph.t < 0.5 || morph.isClosing) morph.open();
      },
      onVerticalDragStart: (_) => _drag = morph.t > 0.02,
      onVerticalDragUpdate: (details) => _onDrag(details, frame.travel),
      onVerticalDragEnd: (details) => _endDrag(details.velocity.pixelsPerSecond.dy, frame.travel),
      onVerticalDragCancel: () => _endDrag(0, frame.travel),
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: scene.radius,
          border: Border.all(color: PayColors.line.withValues(alpha: scene.borderAlpha)),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(color: color, borderRadius: scene.radius),
          child: ClipRRect(
            borderRadius: scene.radius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                OverflowBox(
                  alignment: Alignment.topCenter,
                  minHeight: 0,
                  maxHeight: double.infinity,
                  child: ExcludeSemantics(
                    excluding: scene.t < 0.8,
                    child: IgnorePointer(
                      ignoring: scene.t < 0.86,
                      child: MorphScope(t: scene.t, child: sheet),
                    ),
                  ),
                ),
                if (scene.label > 0.01)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: PayFrame.pillHeight,
                    child: ExcludeSemantics(
                      excluding: scene.label < 0.5,
                      child: Opacity(
                        opacity: scene.label,
                        child: const Center(child: Text('Pay now', style: PayType.pill)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crossfade(FrameMetrics frame, Widget sheet) {
    final t = widget.morph.t;
    return ColoredBox(
      color: PayColors.paper,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const StudioPage(),
          Positioned.fill(child: _dim(t, 0.16 * t)),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: frame.openHeight,
            child: IgnorePointer(
              ignoring: t < 0.85,
              child: Opacity(
                opacity: t,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(PayFrame.sheetRadius)),
                  child: ColoredBox(color: PayColors.sheet, child: MorphScope(t: 1, child: sheet)),
                ),
              ),
            ),
          ),
          Positioned(
            left: frame.side,
            right: frame.side,
            bottom: frame.restBottom,
            height: PayFrame.pillHeight,
            child: IgnorePointer(
              ignoring: t > 0.4,
              child: Opacity(opacity: (1 - t).clamp(0, 1), child: _restPill()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _restPill() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        _setPressed(true);
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.morph.open,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _pressed ? PayColors.inkPressed : PayColors.ink,
          borderRadius: const BorderRadius.all(Radius.circular(PayFrame.pillRadius)),
        ),
        child: const Center(child: Text('Pay now', style: PayType.pill)),
      ),
    );
  }

  Widget _dim(double t, double alpha) {
    return IgnorePointer(
      ignoring: t < 0.18,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.morph.close,
        child: ColoredBox(color: PayColors.ink.withValues(alpha: alpha)),
      ),
    );
  }
}

/// Reads the offer's natural height once, so the sheet can grow past 75%.
class _Measure extends SingleChildRenderObjectWidget {
  const _Measure({required this.onHeight, required super.child});

  final ValueChanged<double> onHeight;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderMeasure(onHeight);

  @override
  void updateRenderObject(BuildContext context, _RenderMeasure renderObject) {
    renderObject.onHeight = onHeight;
  }
}

class _RenderMeasure extends RenderProxyBox {
  _RenderMeasure(this.onHeight);

  ValueChanged<double> onHeight;
  double? _sent;

  @override
  void performLayout() {
    super.performLayout();
    final height = child?.size.height ?? size.height;
    if (_sent != null && (height - _sent!).abs() < 1) return;
    _sent = height;
    WidgetsBinding.instance.addPostFrameCallback((_) => onHeight(height));
  }
}
