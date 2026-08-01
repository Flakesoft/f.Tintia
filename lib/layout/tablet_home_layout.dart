import 'package:flutter/material.dart';

import '../models/image_state.dart';
import '../widgets/home_content.dart';

class TabletHomeLayout extends StatelessWidget {
  final ImageState? imageState;
  final bool isLoading;
  final GlobalKey imageKey;
  final TransformationController transformationController;
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
        Container(
          width: 260,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerLow,
            border: Border(
              right: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant,
              ),
            ),
          ),
          child: const Center(
            child: Text(
              'Sidebar Placeholder',
            ),
          ),
        ),

        Expanded(
          child: HomeContent(
            isLoading: isLoading,
            imageState: imageState,
            imageKey: imageKey,
            transformationController:
                transformationController,
            onImageTap: onImageTap,
            onSelectImage: onSelectImage,
          ),
        ),
      ],
    );
  }
}
