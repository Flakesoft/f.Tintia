import 'package:flutter/material.dart';

import '../models/image_state.dart';
import '../services/image_picker_service.dart';
import '../services/image_processing_service.dart';
import '../services/color_picker_service.dart';
import '../widgets/color_info_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ImageState? imageState;
  bool isLoading = false;

  final GlobalKey _imageKey = GlobalKey();

  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final imageFile = await ImagePickerService.pickImage();

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
        previewBytes: processedImage.previewBytes,
      );

      isLoading = false;
    });
  }

  Future<void> _onImageTap(
    TapUpDetails details,
  ) async {
    if (imageState == null) return;

    final renderBox =
        _imageKey.currentContext?.findRenderObject()
            as RenderBox?;

    if (renderBox == null) return;

    final displayedSize = renderBox.size;

    final localPosition =
        details.localPosition;

    final x =
        (
          localPosition.dx *
          imageState!.image.width /
          displayedSize.width
        ).round();

    final y =
        (
          localPosition.dy *
          imageState!.image.height /
          displayedSize.height
        ).round();

    final color =
        await ColorPickerService.getPixelColor(
      imagePath: imageState!.path,
      x: x,
      y: y,
    );

    if (!mounted || color == null) {
      return;
    }

    setState(() {
      imageState =
          imageState!.copyWith(
        selectedColor: color,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    final maxImageWidth =
        screenWidth > 700
            ? 600.0
            : screenWidth * 0.9;

    final maxImageHeight =
        MediaQuery.of(context).size.height * 0.55;

    return Scaffold(
      appBar: AppBar(
        title: const Text('f.Tintra'),
        centerTitle: true,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),

            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [
                AnimatedSwitcher(
                  duration:
                      const Duration(milliseconds: 250),

                  child: isLoading

                      ? Column(
                          key:
                              const ValueKey('loading'),

                          children: [
                            Icon(
                              Icons.hourglass_top,
                              size: 72,
                              color:
                                  Theme.of(context)
                                      .colorScheme
                                      .primary,
                            ),

                            const SizedBox(height: 20),

                            Text(
                              'Loading image...',
                              style:
                                  Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                            ),
                          ],
                        )

                      : imageState != null

                          ? Column(
                              key:
                                  const ValueKey('image'),

                              children: [
                                SizedBox(
                                  width:
                                      maxImageWidth,

                                  height:
                                      maxImageHeight,

                                  child:
                                      InteractiveViewer(

                                    transformationController:
                                        _transformationController,

                                    minScale:
                                        0.8,

                                    maxScale:
                                        5.0,

                                    panEnabled:
                                        true,

                                    scaleEnabled:
                                        true,

                                    boundaryMargin:
                                        const EdgeInsets.all(
                                      50,
                                    ),

                                    clipBehavior:
                                        Clip.hardEdge,

                                    child:
                                        GestureDetector(
                                      onTapUp:
                                          _onImageTap,

                                      child:
                                          Image.memory(
                                        key:
                                            _imageKey,

                                        imageState!
                                            .previewBytes,

                                        fit:
                                            BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  'Pinch to zoom • Move with two fingers',
                                  style:
                                      Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                ),
                              ],
                            )

                          : Icon(
                              Icons.colorize,

                              key:
                                  const ValueKey('empty'),

                              size: 96,

                              color:
                                  Theme.of(context)
                                      .colorScheme
                                      .primary,
                            ),
                ),

                const SizedBox(height: 24),

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

                const SizedBox(height: 32),

                FilledButton.icon(
                  onPressed:
                      isLoading
                          ? null
                          : _selectImage,

                  icon:
                      const Icon(Icons.image),

                  label:
                      Text(
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