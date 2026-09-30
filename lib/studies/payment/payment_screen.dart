import 'package:flutter/material.dart';

import 'package:interactions/studies/payment/motion/pay_morph.dart';
import 'package:interactions/studies/payment/stage/pay_stage.dart';
import 'package:interactions/studies/payment/theme/pay_style.dart';

/// Study 01. The pay pill and the sheet are one surface.
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with TickerProviderStateMixin {
  late final PayMorph _morph = PayMorph(vsync: this);
  var _canLeave = true;

  @override
  void initState() {
    super.initState();
    _morph.addListener(_gate);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _morph.reduced = MediaQuery.disableAnimationsOf(context);
  }

  void _gate() {
    final next = _morph.canLeave;
    if (next != _canLeave) setState(() => _canLeave = next);
  }

  @override
  void dispose() {
    _morph.removeListener(_gate);
    _morph.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canLeave,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _morph.close();
      },
      child: Scaffold(
        backgroundColor: PayColors.recess,
        body: PayStage(morph: _morph),
      ),
    );
  }
}
