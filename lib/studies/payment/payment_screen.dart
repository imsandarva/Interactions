import 'package:flutter/material.dart';

import 'package:interactions/app/theme/app_colors.dart';
import 'package:interactions/studies/payment/pay_now_button.dart';

/// Study 01. The sheet itself comes later; the first step is the pay action.
class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 12, 24, 16),
          child: Column(
            children: [
              Spacer(),
              PayNowButton(onPressed: onPayNowTapped),
            ],
          ),
        ),
      ),
    );
  }
}

/// Stand-in until the rest of the payment sheet is designed.
void onPayNowTapped() => debugPrint('Tapped');
