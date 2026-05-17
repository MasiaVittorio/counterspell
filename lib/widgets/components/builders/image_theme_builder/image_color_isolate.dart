import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as ip;
import 'package:material_color_utilities/material_color_utilities.dart';

class IsolatedImageColor {
  static Future<int> computeColor(FileInfo fileInfo) async {
    const int size = 100;

    //// this is what they do in ColorScheme.fromImageProvider, but they use ui.Image which we cannot use in an Isolate
    // final ui.Image scaledImage = await _imageProviderToScaled(imageProvider);
    // final ByteData? imageBytes = await scaledImage.toByteData();

    // final QuantizerResult quantizerResult = await QuantizerCelebi().quantize(
    //   imageBytes!.buffer.asUint32List(),
    //   128,
    //   returnInputPixelToClusterPixel: true,
    // );

    ip.Image? image = await ip.decodeImageFile(fileInfo.file.path);
    if (image == null) {
      return 0xFFFF0000;
    }

    ip.Image resizedImage = ip.copyResize(
      image,
      height: size,
      interpolation: ip.Interpolation.nearest,
      maintainAspect: true,
    );

    final pixelCount = resizedImage.width * resizedImage.height;
    final argbPixels = Int32List(pixelCount);

    int i = 0;
    for (final p in resizedImage) {
      argbPixels[i++] =
          ((p.a.toInt() & 0xFF) << 24) |
          ((p.r.toInt() & 0xFF) << 16) |
          ((p.g.toInt() & 0xFF) << 8) |
          (p.b.toInt() & 0xFF);
    }

    final quantizerResult = await QuantizerCelebi().quantize(
      argbPixels,
      128,
      returnInputPixelToClusterPixel: true,
    );

    // Score colors for color scheme suitability.
    final List<int> scoredResults = Score.score(
      quantizerResult.colorToCount,
      desired: 1,
    );

    return scoredResults.first;
  }
}
