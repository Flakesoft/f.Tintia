import 'package:flutter/material.dart';

import '../models/image_state.dart';
import '../services/image_picker_service.dart';
import '../services/image_processing_service.dart';
import '../widgets/color_info_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/image_viewer.dart';
import '../widgets/loading_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ImageState? imageState;

  bool isLoading = false;

  final GlobalKey _imageKey =
      GlobalKey();

  final TransformationController
      _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final imageFile =
        await ImagePickerService.pickImage();

    if (imageFile == null) return;

    setState(() {
      isLoading = true;
    });

    final processedImage =
        await ImageProcessingService.processImage(
      imageFile.path,
    );

    if (processedImage == null) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      return;
    }

    if (!mounted) return;

    _transformationController.value =
        Matrix4.identity();

    setState(() {
      imageState = ImageState(
        path: imageFile.path,
        image: processedImage.image,
        previewBytes:
            processedImage.previewBytes,
      );

      isLoading = false;
    });
  }

  void _onImageTap(
    TapUpDetails details,
  ) {
    if (imageState == null) {
      return;
    }

    final renderBox =
        _imageKey.currentContext
            ?.findRenderObject()
            as RenderBox?;

    if (renderBox == null) {
      return;
    }

    final displayedSize =
        renderBox.size;

    final localPosition =
        details.localPosition;

    final x =
        (localPosition.dx *
                imageState!.image.width /
                displayedSize.width)
            .clamp(
              0,
              imageState!.image.width - 1,
            )
            .round();

    final y =
        (localPosition.dy *
                imageState!.image.height /
                displayedSize.height)
            .clamp(
              0,
              imageState!.image.height - 1,
            )
            .round();

    final pixel =
        imageState!.image.getPixel(
          x,
          y,
        );

    final color =
        Color.fromARGB(
          pixel.a.toInt(),
          pixel.r.toInt(),
          pixel.g.toInt(),
          pixel.b.toInt(),
        );

    setState(() {
      imageState =
          imageState!.copyWith(
        selectedColor: color,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('f.Tintra'),
        centerTitle: true,
      ),

      body: Center(
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
                                  _imageKey,

                              transformationController:
                                  _transformationController,

                              onTap:
                                  _onImageTap,
                            )

                          : const EmptyState(),
                ),

                const SizedBox(
                  height: 24,
                ),

                if (imageState?.selectedColor != null)

                  ColorInfoCard(
                    color:
                        imageState!.selectedColor!,
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
                          : _selectImage,

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
      ),
    );
  }
}