import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageService {

  Future<File?> compressImage(File file) async {
    final targetPath =
        "${file.parent.path}/compressed_${file.uri.pathSegments.last}";

    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 70,
    );

    if (result == null) {
      return null;
    }

    return File(result.path);
  }
}