import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class TFLiteService {
  static const platform = MethodChannel("com.example.tflite/inference");

  static Future<double?> runModelOnImage(XFile pickedFile) async {
    try {
      final result = await platform.invokeMethod("runModel", {
        "imagePath": pickedFile.path,
      });

      return  double.parse(result['confidence'].toString());
    } catch (e) {
      debugPrint("TFLite inference error: $e");
      return null;
    }
  }
}