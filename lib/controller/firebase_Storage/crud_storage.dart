import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FirebaseStorageService {
  final _storage = FirebaseStorage.instance;
  /// Upload a file to a specific path in Firebase Storage
  Future<String?> uploadFile(String storagePath, File file) async {
    try {
      TaskSnapshot snapshot = await _storage.ref(storagePath).putFile(file);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<XFile?> pickImageAndCompress(XFile pickedFile) async {

    final file = File(pickedFile.path);
    final targetPath = '${file.parent.path}/temp_${file.uri.pathSegments.last}';
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80,
      //rotate: 180,
    );
    return result;
  }
  /// Get the download URL of a file
  Future<String?> getDownloadURL(String storagePath) async {
    try {
      return await _storage.ref(storagePath).getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  /// Delete a file from Firebase Storage
  Future<bool> deleteFile(String storagePath) async {
    final storageRef = FirebaseStorage.instance.ref();
    String path=extractFirebasePath(storagePath);
    try {
      final desertRef = storageRef.child(path);
      await desertRef.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  String extractFirebasePath(String url) {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    final encodedPath = segments.contains('o') ? segments[segments.indexOf('o') + 1] : '';
    return Uri.decodeFull(encodedPath);
  }

  /// Check if a file exists (no direct method, uses try-catch)
  Future<bool> fileExists(String storagePath) async {
    try {
      await _storage.ref(storagePath).getDownloadURL();
      return true;
    } catch (e) {
      return false;
    }
  }

}
