import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ColorPickerService {
  static Future<Color?> getPixelColor({
    required String imagePath,
    required int x,
    required int y,
  }) async {
    try {
      final bytes = await File(imagePath).readAsBytes();

      final image = img.decodeImage(bytes);

      if (image == null) {
        return null;
      }

      if (x < 0 ||
          y < 0 ||
          x >= image.width ||
          y >= image.height) {
        return null;
      }

      final pixel = image.getPixel(x, y);

      return Color.fromARGB(
        pixel.a.toInt(),
        pixel.r.toInt(),
        pixel.g.toInt(),
        pixel.b.toInt(),
      );
    } catch (e) {
      debugPrint('Failed to read pixel color: $e');
      return null;
    }
  }

  static String getHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  static String getRgb(Color color) {
    final r = (color.r * 255).round();
    final g = (color.g * 255).round();
    final b = (color.b * 255).round();

    return 'RGB($r, $g, $b)';
  }

  static String getHsv(Color color) {
    final hsv = HSVColor.fromColor(color);

    return 'HSV(${hsv.hue.round()}°, ${(hsv.saturation * 100).round()}%, ${(hsv.value * 100).round()}%)';
  }

  static String getHsl(Color color) {
    final hsl = HSLColor.fromColor(color);

    return 'HSL(${hsl.hue.round()}°, ${(hsl.saturation * 100).round()}%, ${(hsl.lightness * 100).round()}%)';
  }
}