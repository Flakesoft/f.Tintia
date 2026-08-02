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

  const ImageSection({
    super.key,
    required this.isLoading,
    required this.imageState,
    required this.imageKey,
    required this.transformationController,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
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
    );
  }
}
