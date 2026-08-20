import 'package:flutter/material.dart';

import '../models/image_state.dart';
import 'color_info_card.dart';
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
    return Column(
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

        if (imageState?.selectedColor !=
            null)

          ColorInfoCard(
            color:
                imageState!
                    .selectedColor!,
          )

        else if (imageState != null)

          Text(
            'Tap the image to pick a color',

            style:
                Theme.of(context)
                    .textTheme
                    .bodyMedium,
          ),
      ],
    );
  }
}