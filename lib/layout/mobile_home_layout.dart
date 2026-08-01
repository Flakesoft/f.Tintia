import 'package:flutter/material.dart';

import '../models/image_state.dart';
import '../widgets/home_content.dart';

class MobileHomeLayout extends StatelessWidget {
  final ImageState? imageState;
  final bool isLoading;
  final GlobalKey imageKey;
  final TransformationController transformationController;
  final GestureTapUpCallback onImageTap;
  final VoidCallback onSelectImage;

  const MobileHomeLayout({
    super.key,
    required this.imageState,
    required this.isLoading,
    required this.imageKey,
    required this.transformationController,
    required this.onImageTap,
    required this.onSelectImage,
  });

  @override
  Widget build(BuildContext context) {
    return HomeContent(
      isLoading: isLoading,
      imageState: imageState,
      imageKey: imageKey,
      transformationController:
          transformationController,
      onImageTap: onImageTap,
      onSelectImage: onSelectImage,
    );
  }
}
