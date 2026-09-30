import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:interactions/studies/payment/offer/plus_plans.dart';
import 'package:interactions/studies/payment/sheet/rolling_text.dart';
import 'package:interactions/studies/payment/theme/pay_style.dart';

/// Two equal cards and one highlight that slides between them.
class PlanPicker extends StatefulWidget {
  const PlanPicker({required this.plans, required this.selected, required this.onSelect, super.key});

  final List<PayPlan> plans;
  final PayCycle selected;
  final ValueChanged<PayCycle> onSelect;

  @override
  State<PlanPicker> createState() => _PlanPickerState();
}

class _PlanPickerState extends State<PlanPicker> {
  final _yearlyKey = GlobalKey();
  final _monthlyKey = GlobalKey();
  var _yearlyH = 108.0;
  var _monthlyH = 108.0;
  var _live = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    if (!mounted) return;
    final yearly = _yearlyKey.currentContext?.size?.height ?? _yearlyH;
    final monthly = _monthlyKey.currentContext?.size?.height ?? _monthlyH;
    if ((yearly - _yearlyH).abs() < 0.5 && (monthly - _monthlyH).abs() < 0.5 && _live) return;
    setState(() {
      _yearlyH = yearly;
      _monthlyH = monthly;
      _live = true;
    });
  }

  void _select(PayCycle cycle) {
    if (cycle == widget.selected) return;
    HapticFeedback.selectionClick();
    widget.onSelect(cycle);
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    final yearly = widget.selected == PayCycle.yearly;
    final top = yearly ? 0.0 : _yearlyH + _gap;
    final height = yearly ? _yearlyH : _monthlyH;
    final glide = !_live || reduced ? Duration.zero : const Duration(milliseconds: 280);
    return Stack(
      children: [
        AnimatedPositioned(
          duration: glide,
          curve: Curves.easeOutCubic,
          top: top,
          height: height,
          left: 0,
          right: 0,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: PayColors.tint,
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
          ),
        ),
        Column(
          children: [
            _card(widget.plans[0], _yearlyKey),
            const SizedBox(height: _gap),
            _card(widget.plans[1], _monthlyKey),
          ],
        ),
        AnimatedPositioned(
          duration: glide,
          curve: Curves.easeOutCubic,
          top: top,
          height: height,
          left: 0,
          right: 0,
          child: const IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(18)),
                border: Border.fromBorderSide(BorderSide(color: PayColors.ink, width: 1.5)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _card(PayPlan plan, GlobalKey key) {
    final selected = plan.cycle == widget.selected;
    return Semantics(
      button: true,
      selected: selected,
      label: plan.name,
      child: GestureDetector(
        key: key,
        behavior: HitTestBehavior.opaque,
        onTap: () => _select(plan.cycle),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(18)),
            border: Border.all(color: PayColors.line),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
            child: Row(
              children: [
                Expanded(child: _copy(plan)),
                const SizedBox(width: 12),
                _Ring(filled: selected),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _copy(PayPlan plan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          child: Row(
            children: [
              Text(plan.name, style: PayType.planName),
              if (plan.badge != null) ...[
                const SizedBox(width: 8),
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: PayColors.sageWash,
                    borderRadius: BorderRadius.all(Radius.circular(99)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    child: Text(plan.badge!, style: PayType.badge),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 6),
        RollingText(text: plan.priceLine, style: PayType.price),
        const SizedBox(height: 4),
        RollingText(text: plan.detail, style: PayType.caption),
      ],
    );
  }
}

const _gap = 10.0;

class _Ring extends StatelessWidget {
  const _Ring({required this.filled});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: filled ? PayColors.ink : PayColors.inkFaint, width: 1.5),
        ),
        child: Center(
          child: AnimatedScale(
            scale: filled ? 1 : 0,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            child: const DecoratedBox(
              decoration: BoxDecoration(shape: BoxShape.circle, color: PayColors.ink),
              child: SizedBox.square(dimension: 10),
            ),
          ),
        ),
      ),
    );
  }
}
