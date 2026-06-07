import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    required this.title,
    this.onMenuPressed,
    super.key,
  });

  final String title;
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: onMenuPressed == null
                ? const SizedBox(width: 48)
                : IconButton(
                    key: const Key('app-header-menu-button'),
                    tooltip: 'Menu',
                    onPressed: onMenuPressed,
                    icon: const Icon(Icons.menu),
                  ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
