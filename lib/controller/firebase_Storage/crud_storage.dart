import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

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
    try {
      await _storage.ref(storagePath).delete();
      return true;
    } catch (e) {
      return false;
    }
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
