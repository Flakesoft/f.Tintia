import 'dart:io';
import 'dart:typed_data';
import 'dart:isolate';

import 'package:image/image.dart' as img;

class ProcessedImage {
  final img.Image image;
  final Uint8List previewBytes;

  const ProcessedImage({
    required this.image,
    required this.previewBytes,
  });
}

class ImageProcessingService {
  static Future<ProcessedImage?> processImage(
    String path,
  ) async {
    return Isolate.run(() {

      final bytes =
          File(path).readAsBytesSync();

      final decoded =
          img.decodeImage(bytes);

      if (decoded == null) {
        return null;
      }


      // Limit image size for fast color picking
      final processed =
          img.copyResize(
            decoded,
            width: decoded.width > 1200
                ? 1200
                : decoded.width,
          );


      final previewBytes =
          Uint8List.fromList(
            img.encodePng(
              processed,
            ),
          );


      return ProcessedImage(
        image: processed,
        previewBytes: previewBytes,
      );
    });
  }
}