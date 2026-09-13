import 'package:flutter/material.dart';

import '../layout/adaptive_layout.dart';
import '../layout/desktop_home_layout.dart';
import '../layout/layout_breakpoints.dart';
import '../layout/mobile_home_layout.dart';
import '../layout/tablet_home_layout.dart';
import '../models/image_state.dart';
import '../services/image_picker_service.dart';
import '../services/image_processing_service.dart';
import '../widgets/app_sidebar.dart';
import 'color_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

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

    if (imageFile == null) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final processedImage = await ImageProcessingService.processImage(
      imageFile.path,
    );

    if (processedImage == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });

      return;
    }

    if (!mounted) {
      return;
    }

    _transformationController.value = Matrix4.identity();

    setState(() {
      imageState = ImageState(
        path: imageFile.path,
        image: processedImage.image,
        previewBytes: processedImage.previewBytes,
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

    final renderBox = _imageKey.currentContext
        ?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      return;
    }

    final displayedSize = renderBox.size;
    final localPosition = details.localPosition;

    final x = (localPosition.dx *
            imageState!.image.width /
            displayedSize.width)
        .clamp(
          0,
          imageState!.image.width - 1,
        )
        .round();

    final y = (localPosition.dy *
            imageState!.image.height /
            displayedSize.height)
        .clamp(
          0,
          imageState!.image.height - 1,
        )
        .round();

    final pixel = imageState!.image.getPixel(x, y);

    final color = Color.fromARGB(
      pixel.a.toInt(),
      pixel.r.toInt(),
      pixel.g.toInt(),
      pixel.b.toInt(),
    );

    setState(() {
      imageState = imageState!.copyWith(
        selectedColor: color,
      );
    });
  }

  void _openColorHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ColorHistoryScreen(),
      ),
    );
  }

  void _onNavigationSelected(
    BuildContext context,
    int index,
  ) {
    // Home
    if (index == 0) {
      Navigator.of(context).pop();
      return;
    }

    // Color History
    if (index == 1) {
      Navigator.of(context).pop();

      _openColorHistory();
      return;
    }

    // Color Palette and Settings are not implemented yet.
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This section is coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return AppSidebar(
      onDestinationSelected: (index) {
        _onNavigationSelected(context, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final width = constraints.maxWidth;

        final isMobile = !LayoutBreakpoints.isTablet(width) &&
            !LayoutBreakpoints.isDesktop(width);

        return Scaffold(
          appBar: AppBar(
            title: const Text('f.Tintia'),
            centerTitle: true,
            leading: isMobile
                ? Builder(
                    builder: (context) {
                      return IconButton(
                        icon: const Icon(Icons.menu),
                        tooltip: 'Open menu',
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      );
                    },
                  )
                : null,
          ),
          drawer: isMobile
              ? Drawer(
                  child: _buildSidebar(context),
                )
              : null,
          body: AdaptiveLayout(
            mobile: MobileHomeLayout(
              imageState: imageState,
              isLoading: isLoading,
              imageKey: _imageKey,
              transformationController: _transformationController,
              onImageTap: _onImageTap,
              onSelectImage: _selectImage,
            ),
            tablet: TabletHomeLayout(
              imageState: imageState,
              isLoading: isLoading,
              imageKey: _imageKey,
              transformationController: _transformationController,
              onImageTap: _onImageTap,
              onSelectImage: _selectImage,
            ),
            desktop: DesktopHomeLayout(
              imageState: imageState,
              isLoading: isLoading,
              imageKey: _imageKey,
              transformationController: _transformationController,
              onImageTap: _onImageTap,
              onSelectImage: _selectImage,
            ),
          ),
        );
      },
    );
  }
}