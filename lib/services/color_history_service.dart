import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorHistoryService {
  static const String _storageKey = 'saved_colors';

  static Future<List<Color>> getSavedColors() async {
    final preferences = await SharedPreferences.getInstance();

    final values =
        preferences.getStringList(_storageKey) ?? [];

    return values
        .map(_colorFromHex)
        .whereType<Color>()
        .toList();
  }

  static Future<void> saveColor(Color color) async {
    final preferences =
        await SharedPreferences.getInstance();

    final colors =
        preferences.getStringList(_storageKey) ?? [];

    final hex =
        color.toARGB32().toRadixString(16).substring(2).toUpperCase();

    final normalizedHex = '#$hex';

    if (colors.contains(normalizedHex)) {
      return;
    }

    colors.add(normalizedHex);

    await preferences.setStringList(
      _storageKey,
      colors,
    );
  }

  static Future<void> removeColor(Color color) async {
    final preferences =
        await SharedPreferences.getInstance();

    final colors =
        preferences.getStringList(_storageKey) ?? [];

    final hex =
        color.toARGB32().toRadixString(16).substring(2).toUpperCase();

    final normalizedHex = '#$hex';

    colors.remove(normalizedHex);

    await preferences.setStringList(
      _storageKey,
      colors,
    );
  }

  static Future<void> clearColors() async {
    final preferences =
        await SharedPreferences.getInstance();

    await preferences.remove(_storageKey);
  }

  static bool containsColor(
    List<Color> colors,
    Color color,
  ) {
    return colors.any(
      (savedColor) =>
          savedColor.toARGB32() ==
          color.toARGB32(),
    );
  }

  static Color? _colorFromHex(String hex) {
    try {
      final normalized =
          hex.replaceFirst('#', '');

      if (normalized.length != 6) {
        return null;
      }

      final value =
          int.parse('FF$normalized', radix: 16);

      return Color(value);
    } catch (_) {
      return null;
    }
  }
}