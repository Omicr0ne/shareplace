import 'package:flutter/material.dart';

class DealTagChips extends StatelessWidget {
  const DealTagChips({
    required this.tags,
    this.compact = false,
    super.key,
  });

  final List<String> tags;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: tags
          .map((tag) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 8 : 10,
                vertical: compact ? 3 : 5,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFFFCC80)),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  color: const Color(0xFF5D4037),
                  fontSize: compact ? 10 : 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          })
          .toList(growable: false),
    );
  }
}
