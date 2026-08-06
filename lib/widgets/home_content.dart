import 'package:flutter/material.dart';

import '../models/image_state.dart';
import 'color_panel.dart';
import 'image_section.dart';

class HomeContent extends StatelessWidget {
  final bool isLoading;

  final ImageState? imageState;

  final GlobalKey imageKey;

  final TransformationController
      transformationController;

  final GestureTapUpCallback onImageTap;

  final VoidCallback onSelectImage;

  const HomeContent({
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
    return Center(
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.all(24),

        child: ConstrainedBox(
          constraints:
              const BoxConstraints(
            maxWidth: 700,
          ),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              ImageSection(
                isLoading: isLoading,

                imageState: imageState,

                imageKey: imageKey,

                transformationController:
                    transformationController,

                onImageTap: onImageTap,

                onSelectImage:
                    onSelectImage,
              ),

              const SizedBox(
                height: 24,
              ),

              ColorPanel(
                imageState: imageState,

                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
