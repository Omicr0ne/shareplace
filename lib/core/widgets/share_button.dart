import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

typedef ShareAction =
    Future<void> Function({
      required String text,
      String? subject,
      String? title,
    });

class ShareButton extends StatelessWidget {
  const ShareButton({
    required this.text,
    this.title,
    this.subject,
    this.icon = Icons.share_outlined,
    this.color,
    this.onShare,
    super.key,
  });

  final String text;
  final String? title;
  final String? subject;
  final IconData icon;
  final Color? color;
  final ShareAction? onShare;

  Future<void> _share() async {
    final customShare = onShare;
    if (customShare != null) {
      await customShare(text: text, subject: subject, title: title);
      return;
    }

    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: subject,
        title: title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _share,
      icon: Icon(icon, color: color),
      tooltip: 'Partager',
    );
  }
}
