import 'package:flutter/material.dart';

import '../models/image_state.dart';
import '../widgets/color_info_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/image_viewer.dart';
import '../widgets/loading_state.dart';

class MobileHomeLayout extends StatelessWidget {
  final ImageState? imageState;
  final bool isLoading;
  final GlobalKey imageKey;
  final TransformationController transformationController;
  final ValueChanged<TapUpDetails> onImageTap;
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
              AnimatedSwitcher(
                duration:
                    const Duration(
                      milliseconds: 250,
                    ),

                child: isLoading
                    ? const LoadingState()

                    : imageState != null
                        ? ImageViewer(
                            key:
                                const ValueKey(
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

              const SizedBox(
                height: 32,
              ),

              FilledButton.icon(
                onPressed:
                    isLoading
                        ? null
                        : onSelectImage,

                icon:
                    const Icon(
                  Icons.image,
                ),

                label: Text(
                  imageState == null
                      ? 'Select image'
                      : 'Choose another image',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
