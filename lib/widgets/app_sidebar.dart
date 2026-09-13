import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  const AppSidebar({
    super.key,
    this.selectedIndex = 0,
    this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected:
          onDestinationSelected,
      children: const [
        Padding(
          padding: EdgeInsets.fromLTRB(
            28,
            24,
            16,
            12,
          ),
          child: Text(
            'f.Tintia',
          ),
        ),

        NavigationDrawerDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('home'),
        ),

        NavigationDrawerDestination(
          icon: Icon(
            Icons.history_outlined,
          ),
          selectedIcon: Icon(
            Icons.history,
          ),
          label: Text('color history'),
        ),

        NavigationDrawerDestination(
          icon: Icon(
            Icons.palette_outlined,
          ),
          selectedIcon: Icon(
            Icons.palette,
          ),
          label: Text('color palette'),
        ),

        NavigationDrawerDestination(
          icon: Icon(
            Icons.settings_outlined,
          ),
          selectedIcon: Icon(
            Icons.settings,
          ),
          label: Text('settings'),
        ),
      ],
    );
  }
}
