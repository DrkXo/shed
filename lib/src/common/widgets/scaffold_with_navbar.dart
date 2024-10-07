// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shed/src/router/routes.dart';
import 'package:window_manager/window_manager.dart';

class ScaffoldWithNavBar extends ConsumerStatefulWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends ConsumerState<ScaffoldWithNavBar> {
  bool expanded = true;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DragToMoveArea(
            child: NavigationRail(
              selectedIndex: selectedIndex,
              extended: expanded,
              useIndicator: false,
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8.0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [],
                    ),
                  ),
                ),
              ),
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text("Home"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text("Settings"),
                ),
              ],
              onDestinationSelected: (value) {
                // logger.i('$selectedIndex  $value');
                if (value != selectedIndex) {
                  selectedIndex = value;

                  switch (value) {
                    case 0:
                      context.goNamed(Routes.downloads.name);
                      break;
                    case 1:
                      context.goNamed(Routes.settings.name);
                      break;
                  }
                  setState(() {});
                }
              },
            ),
          ),
          Expanded(
            flex: 5,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
