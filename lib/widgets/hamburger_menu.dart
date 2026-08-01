import 'package:flutter/material.dart';

class HamburgerMenu extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  const HamburgerMenu({
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
            'f.Tintra',
          ),
        ),

        NavigationDrawerDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Home'),
        ),

        NavigationDrawerDestination(
          icon: Icon(
            Icons.history_outlined,
          ),
          selectedIcon: Icon(
            Icons.history,
          ),
          label: Text('Color History'),
        ),

        NavigationDrawerDestination(
          icon: Icon(
            Icons.palette_outlined,
          ),
          selectedIcon: Icon(
            Icons.palette,
          ),
          label: Text('Color Palette'),
        ),

        NavigationDrawerDestination(
          icon: Icon(
            Icons.settings_outlined,
          ),
          selectedIcon: Icon(
            Icons.settings,
          ),
          label: Text('Settings'),
        ),
      ],
    );
  }
}
