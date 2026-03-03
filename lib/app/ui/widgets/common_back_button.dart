import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CommonBackButton extends StatelessWidget {
  const CommonBackButton({super.key, required this.onTapBackBtn});
  final VoidCallback onTapBackBtn;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapBackBtn,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: ShadTheme.of(context).colorScheme.muted, shape: BoxShape.circle),
        child: Icon(Icons.arrow_back, color: ShadTheme.of(context).colorScheme.mutedForeground),
      ),
    );
  }
}
