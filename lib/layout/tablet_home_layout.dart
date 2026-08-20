import 'package:flutter/material.dart';

import '../models/image_state.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/home_content.dart';

class TabletHomeLayout extends StatelessWidget {
  final ImageState? imageState;

  final bool isLoading;

  final GlobalKey imageKey;

  final TransformationController
      transformationController;

  final GestureTapUpCallback onImageTap;

  final VoidCallback onSelectImage;

  const TabletHomeLayout({
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
    return Row(
      children: [
        const SizedBox(
          width: 260,
          child: AppSidebar(),
        ),

        Expanded(
          child: HomeContent(
            isLoading: isLoading,

            imageState: imageState,

            imageKey: imageKey,

            transformationController:
                transformationController,

            onImageTap: onImageTap,

            onSelectImage:
                onSelectImage,
          ),
        ),
      ],
    );
  }
}