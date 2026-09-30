import 'package:flutter/widgets.dart';

import 'package:interactions/studies/payment/motion/morph_scene.dart';
import 'package:interactions/studies/payment/offer/plus_plans.dart';
import 'package:interactions/studies/payment/sheet/commit_button.dart';
import 'package:interactions/studies/payment/sheet/plan_picker.dart';
import 'package:interactions/studies/payment/sheet/reveal.dart';
import 'package:interactions/studies/payment/sheet/rolling_text.dart';
import 'package:interactions/studies/payment/sheet/sheet_close.dart';
import 'package:interactions/studies/payment/theme/pay_style.dart';

class SheetBody extends StatefulWidget {
  const SheetBody({required this.scroll, required this.onClose, this.fill, super.key});

  final ScrollController scroll;
  final VoidCallback onClose;

  /// Null while we measure the offer. Otherwise the sheet's open height.
  final double? fill;

  @override
  State<SheetBody> createState() => _SheetBodyState();
}

class _SheetBodyState extends State<SheetBody> {
  var _cycle = PayCycle.yearly;

  @override
  Widget build(BuildContext context) {
    final plans = PlusOffer.plansFor(DateTime.now());
    final selected = plans.firstWhere((plan) => plan.cycle == _cycle);
    final bottom = MediaQuery.paddingOf(context).bottom;
    final column = Column(
      mainAxisSize: widget.fill == null ? MainAxisSize.min : MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _topBar(),
        if (widget.fill == null)
          _middle(plans)
        else
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scroll,
              primary: false,
              physics: const ClampingScrollPhysics(),
              child: _middle(plans),
            ),
          ),
        const SizedBox(height: 16),
        Reveal(
          amount: PayReveal.trust,
          child: RollingText(text: selected.renews, style: PayType.caption, align: Alignment.center),
        ),
        const SizedBox(height: 10),
        Reveal(amount: PayReveal.cta, child: CommitButton(label: selected.commit)),
      ],
    );
    final padded = Padding(
      padding: EdgeInsets.fromLTRB(24, 4, 24, bottom + 12),
      child: column,
    );
    final fill = widget.fill;
    if (fill == null) return padded;
    return SizedBox(height: fill, child: padded);
  }

  Widget _topBar() {
    return SizedBox(
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Reveal(
            amount: PayReveal.header,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFFD9D3CB),
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
              child: SizedBox(width: 36, height: 4),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Reveal(amount: PayReveal.close, child: SheetClose(onPressed: widget.onClose)),
          ),
        ],
      ),
    );
  }

  Widget _middle(List<PayPlan> plans) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Reveal(amount: PayReveal.header, child: _header()),
          const SizedBox(height: 18),
          Reveal(amount: PayReveal.benefits, child: _benefits()),
          const SizedBox(height: 18),
          Reveal(
            amount: PayReveal.plans,
            child: PlanPicker(
              plans: plans,
              selected: _cycle,
              onSelect: (cycle) => setState(() => _cycle = cycle),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PLUS', style: PayType.tag),
        SizedBox(height: 8),
        Text('Do more with Plus', style: PayType.title),
        SizedBox(height: 8),
        Text('Keep every project, and send it out faster.', style: PayType.body),
      ],
    );
  }

  Widget _benefits() {
    return Column(
      children: [
        for (final benefit in PlusOffer.benefits) ...[
          _benefit(benefit),
          if (benefit != PlusOffer.benefits.last) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _benefit(String label) {
    return Row(
      children: [
        const _Check(),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: PayType.bodyInk)),
      ],
    );
  }
}

class _Check extends StatelessWidget {
  const _Check();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 18,
      height: 18,
      child: CustomPaint(painter: _CheckPainter()),
    );
  }
}

class _CheckPainter extends CustomPainter {
  const _CheckPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = PayColors.inkSoft
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.52)
      ..lineTo(size.width * 0.4, size.height * 0.74)
      ..lineTo(size.width * 0.82, size.height * 0.28);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) => false;
}
