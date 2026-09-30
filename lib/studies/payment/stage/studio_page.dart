import 'package:flutter/material.dart';

import 'package:interactions/studies/payment/theme/pay_style.dart';

/// Quiet locked preview, so the sheet has something to rise over.
class StudioPage extends StatelessWidget {
  const StudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: PayColors.paper,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 18, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Studio', style: PayType.studioTitle),
              SizedBox(height: 6),
              Text('Finished work, kept together.', style: PayType.body),
              SizedBox(height: 28),
              _LockedRow(title: 'Unlimited projects', note: 'Every version, in one place.'),
              SizedBox(height: 10),
              _LockedRow(title: 'Priority exports', note: 'Send work out without the wait.'),
              SizedBox(height: 10),
              _LockedRow(title: 'Early access', note: 'New tools, a little early.'),
            ],
          ),
        ),
      ),
    );
  }
}

class _LockedRow extends StatelessWidget {
  const _LockedRow({required this.title, required this.note});

  final String title;
  final String note;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: PayColors.sheet,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: PayColors.line),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: PayType.bodyInk),
                  const SizedBox(height: 2),
                  Text(note, style: PayType.caption),
                ],
              ),
            ),
            const Icon(Icons.lock_outline, size: 16, color: PayColors.inkFaint),
          ],
        ),
      ),
    );
  }
}
