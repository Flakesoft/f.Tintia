import 'package:flutter/material.dart';

import '../models/image_state.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/desktop_color_panel.dart';
import '../widgets/image_section.dart';

class DesktopHomeLayout extends StatelessWidget {
  final ImageState? imageState;

  final bool isLoading;

  final GlobalKey imageKey;

  final TransformationController
      transformationController;

  final GestureTapUpCallback onImageTap;

  final VoidCallback onSelectImage;

  const DesktopHomeLayout({
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
          width: 280,
          child: AppSidebar(),
        ),

        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.all(24),

              child: ImageSection(
                isLoading: isLoading,

                imageState: imageState,

                imageKey: imageKey,

                transformationController:
                    transformationController,

                onImageTap:
                    onImageTap,

                onSelectImage:
                    onSelectImage,
              ),
            ),
          ),
        ),

        SizedBox(
          width: 320,
          child: DesktopColorPanel(
            imageState: imageState,
          ),
        ),
      ],
    );
  }
}