import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ImageState {
  final String path;

  // Optimized image used for picking colors
  final img.Image image;

  final Uint8List previewBytes;

  final Color? selectedColor;

  const ImageState({
    required this.path,
    required this.image,
    required this.previewBytes,
    this.selectedColor,
  });

  ImageState copyWith({
    String? path,
    img.Image? image,
    Uint8List? previewBytes,
    Color? selectedColor,
  }) {
    return ImageState(
      path: path ?? this.path,
      image: image ?? this.image,
      previewBytes: previewBytes ?? this.previewBytes,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }
}