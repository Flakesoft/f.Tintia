import 'package:flutter/material.dart';

import '../models/image_state.dart';

class ImageViewer extends StatefulWidget {
  final ImageState imageState;
  final GlobalKey imageKey;
  final TransformationController transformationController;
  final Function(TapUpDetails) onTap;

  const ImageViewer({
    super.key,
    required this.imageState,
    required this.imageKey,
    required this.transformationController,
    required this.onTap,
  });

  @override
  State<ImageViewer> createState() =>
      _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  Offset? _pickerPosition;

  bool _isMultiTouch = false;

  int _pointerCount = 0;


  void _handleTap(TapUpDetails details) {
    if (_isMultiTouch) {
      return;
    }

    setState(() {
      _pickerPosition =
          details.localPosition;
    });

    widget.onTap(details);
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
        MediaQuery.of(context).size.height *
            0.55;


    return Column(
      children: [
        SizedBox(
          width: maxImageWidth,

          height: maxImageHeight,

          child: InteractiveViewer(
            transformationController:
                widget.transformationController,

            minScale:
                0.8,

            maxScale:
                5.0,

            panEnabled:
                true,

            scaleEnabled:
                true,

            boundaryMargin:
                const EdgeInsets.all(50),

            clipBehavior:
                Clip.hardEdge,


            child: Listener(
              onPointerDown: (_) {
                _pointerCount++;

                if (_pointerCount > 1) {
                  setState(() {
                    _isMultiTouch = true;
                    _pickerPosition = null;
                  });
                }
              },


              onPointerUp: (_) {
                _pointerCount--;

                if (_pointerCount <= 1) {
                  _isMultiTouch = false;
                }
              },


              child: GestureDetector(
                onTapUp:
                    _handleTap,


                child: Stack(
                  children: [

                    Image.memory(
                      key:
                          widget.imageKey,

                      widget.imageState.previewBytes,

                      fit:
                          BoxFit.contain,
                    ),


                    if (_pickerPosition != null &&
                        widget.imageState.selectedColor != null)

                      Positioned(
                        left:
                            _pickerPosition!.dx - 20,

                        top:
                            _pickerPosition!.dy - 20,


                        child: IgnorePointer(
                          child: Container(
                            width:
                                40,

                            height:
                                40,

                            decoration:
                                BoxDecoration(
                              shape:
                                  BoxShape.circle,

                              color:
                                  widget.imageState.selectedColor,

                              border:
                                  Border.all(
                                color:
                                    Colors.white,

                                width:
                                    3,
                              ),

                              boxShadow: const [
                                BoxShadow(
                                  blurRadius:
                                      6,

                                  color:
                                      Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),


        const SizedBox(
          height:
              8,
        ),


        Text(
          'Pinch to zoom • Move with two fingers',

          style:
              Theme.of(context)
                  .textTheme
                  .bodySmall,
        ),
      ],
    );
  }
}
