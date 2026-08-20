import 'package:flutter/material.dart';

import '../models/image_state.dart';
import 'empty_state.dart';
import 'image_viewer.dart';
import 'loading_state.dart';

class ImageSection extends StatelessWidget {
  final bool isLoading;

  final ImageState? imageState;

  final GlobalKey imageKey;

  final TransformationController
      transformationController;

  final GestureTapUpCallback onImageTap;

  final VoidCallback onSelectImage;

  const ImageSection({
    super.key,
    required this.isLoading,
    required this.imageState,
    required this.imageKey,
    required this.transformationController,
    required this.onImageTap,
    required this.onSelectImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(
            milliseconds: 250,
          ),

          child: isLoading

              ? const LoadingState()

              : imageState != null

                  ? ImageViewer(
                      key: const ValueKey(
                        'image',
                      ),

                      imageState:
                          imageState!,

                      imageKey:
                          imageKey,

                      transformationController:
                          transformationController,

                      onTap:
                          onImageTap,
                    )

                  : const EmptyState(),
        ),

        const SizedBox(
          height: 32,
        ),

        FilledButton.icon(
          onPressed:
              isLoading
                  ? null
                  : onSelectImage,

          icon: const Icon(
            Icons.image,
          ),

          label: Text(
            imageState == null
                ? 'Select image'
                : 'Choose another image',
          ),
        ),
      ],
    );
  }
}