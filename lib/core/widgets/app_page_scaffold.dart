import 'package:flutter/material.dart';
import 'package:shareplace/core/widgets/app_header.dart';
import 'package:shareplace/core/widgets/app_navigation_drawer.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    required this.title,
    required this.body,
    this.currentRoute,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    super.key,
  });

  final String title;
  final Widget body;
  final String? currentRoute;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;

  bool get _hasDrawer => currentRoute != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: _hasDrawer
          ? AppNavigationDrawer(currentRoute: currentRoute!)
          : null,
      body: SafeArea(
        child: Column(
          children: [
            Builder(
              builder: (context) {
                return AppHeader(
                  title: title,
                  onMenuPressed: _hasDrawer
                      ? () => Scaffold.of(context).openDrawer()
                      : null,
                );
              },
            ),
            Expanded(child: body),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
