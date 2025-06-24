import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseCRUDProvider = Provider<FirebaseFireStoreServices>((ref) => FirebaseFireStoreServices());

class FirebaseFireStoreServices {
  final _fireStore = FirebaseFirestore.instance;

  Future<bool> documentExists(String collectionPath, String docId) async {
    try {
      DocumentSnapshot doc = await _fireStore.collection(collectionPath).doc(docId).get();
      return doc.exists;
    } catch (e) {
     // print(e.toString());
      return false;
    }
  }

  updateArrayElements(String path, String id, String field, Map<String,dynamic> data) async {
    try{
    await _fireStore.collection(path).doc(id).update({
    field: FieldValue.arrayUnion([data])
    });
    }catch(e){
      throw ArgumentError('data must be either a List or a Map<String, dynamic>');
    }
  }

  removeArrayElement(String path, String id, String attribute, dynamic data) async {
    if (data is List) {
      await _fireStore.collection(path).doc(id).update({
        attribute: FieldValue.arrayRemove(data)
      });
    } else if (data is Map<String, dynamic>) {
      await _fireStore.collection(path).doc(id).update({
        attribute: FieldValue.arrayRemove([data])
      });
    } else {
      throw ArgumentError('data must be either a List or a Map<String, dynamic>');
    }
  }
  Stream<QuerySnapshot<Map<String, dynamic>>>? getDocuments(String collectionName) {
    return _fireStore.collection(collectionName).snapshots();

  }

  Future<Map<String,dynamic>?> getDoc(String collectionPath, String docId)async{
    try{
     final documentSnapshot= await _fireStore.collection(collectionPath).doc(docId).get();
    if(documentSnapshot.data()!=null && documentSnapshot.exists){
      return documentSnapshot.data();
    }else{
      return null;
    }
    }catch (e){
      return null;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSubCollectionDocuments(String collectionName, String id,
      String subCollectionPath) {
    return _fireStore.collection(collectionName).doc(id).collection(subCollectionPath).snapshots();
  }


  Future<bool> createDocumentWithId(String collectionPath, String id, dynamic data) async {
    try {
      await _fireStore.collection(collectionPath).doc(id).set(data);
      return true;
    } catch (e) {
      print("Error:$e");
      return false;
    }
  }
  Future<bool> createDocument(String collectionPath, dynamic data) async {
    try {
      await _fireStore.collection(collectionPath).doc().set(data);
      return true;
    } catch (e) {
      print("Error:$e");
      return false;
    }
  }

  Future<bool> createSubCollectionDocument(String collectionPath,String id,String subCollectionPath, dynamic data) async {
    try {
      await _fireStore.collection(collectionPath).doc(id).collection(subCollectionPath).add(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDocument(String collectionPath, String docId, dynamic data) async {
    try {
      await _fireStore.collection(collectionPath).doc(docId).update(data);
      return true;
    } catch (e) {
     return false;
    }
  }

  Future<bool> updateSubCollectionDocument(String collectionPath,String docId,String subCollection,String subDocId, dynamic data) async {
    try {
      await _fireStore.collection(collectionPath).doc(docId).collection(subCollection).doc(subDocId).update(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool>deleteDocument(String collectionPath, String docId) async {
    try {
      await _fireStore.collection(collectionPath).doc(docId).delete();
      return true;
    } catch (e) {
     return false;
    }
  }
}
