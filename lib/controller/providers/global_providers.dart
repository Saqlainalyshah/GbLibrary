import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../authentication/auth_repository.dart';
import '../firebase_crud_operations/firestore_crud_operations.dart';
import 'package:booksexchange/model/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/post_model.dart';

class MapDataNotifier extends StateNotifier<Map<String,dynamic>?>{
  MapDataNotifier():super(null);

  getMapData(String collectionPath, String uid) async{
    FirebaseFireStoreServices _firestore=FirebaseFireStoreServices();
    final documentSnapshot=await _firestore.getDoc(collectionPath, uid);
    if(documentSnapshot!=null){
      state=documentSnapshot;
      // return documentSnapshot;
    }else{
      state=null;
    }
  }
}
final mapDataProvider = StateNotifierProvider<MapDataNotifier, Map<String, dynamic>?>(
      (ref) => MapDataNotifier(),
);



final currentUserAuthStatus = StreamProvider<User?>((ref) async* {
  // Delay the stream for 2 seconds
  await Future.delayed(Duration(seconds: 2));
  AuthRepository authRepository=AuthRepository();
  yield* authRepository.authStateChange;
});


final getUserDocument = FutureProvider<UserProfile?>((ref) async {
  final user=FirebaseAuth.instance.currentUser;
  if(user!=null){
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      if(data!=null){
        final temp=UserProfile.fromJson(data);
        ref.read(userProfileProvider.notifier).state=temp;
      }
      return data != null ? UserProfile.fromJson(data) : null;
    } else {
      return null;
    }
  }else{
    return null;
  }
});


final userProfileProvider=StateProvider<UserProfile?>((ref)=>null);


final booksFeedProvider = StreamProvider<List<BooksModel>>((ref) {
  final user=FirebaseAuth.instance.currentUser;
  if(user!=null){
    return FirebaseFirestore.instance
        .collection('posts')
        .where('userID', isNotEqualTo:user.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return BooksModel.fromJson(data);
      }).toList();
    });
  }else{
    return FirebaseFirestore.instance
        .collection('posts')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return BooksModel.fromJson(data);
      }).toList();
    });
  }
});




final uniformFeedProvider = StreamProvider<List<ClothesModel>>((ref) {
  final user=FirebaseAuth.instance.currentUser;
  if(user!=null){
    return FirebaseFirestore.instance
        .collection('clothes')
        .where('userID', isNotEqualTo:user.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ClothesModel.fromJson(data);
      }).toList();
    });
  }else{
    return FirebaseFirestore.instance
        .collection('clothes')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ClothesModel.fromJson(data);
      }).toList();
    });
  }
});


/*final myBooksPosts = StreamProvider<List<BookIds>>((ref) {
  return FirebaseFirestore.instance
      .collection('posts')
      .where('userID', isEqualTo:FirebaseAuth.instance.currentUser!.uid)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return BookIds.fromJson(data);
    }).toList();
  });
});*/
final myBooksPosts = StreamProvider<List<BookIds>>((ref) {
  final data = FirebaseFirestore.instance
      .collection('posts')
      .where('userID', isEqualTo:FirebaseAuth.instance.currentUser!.uid)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs.map(
          (doc) => BookIds(
        booksModel: BooksModel.fromJson(doc.data()),
        docId: doc.id,
      ),
    ).toList(),
  );
  return data;
});


class BookIds {
  final BooksModel booksModel;
  final String docId;

  BookIds({required this.booksModel, required this.docId});

  factory BookIds.fromJson(Map<String, dynamic> json) {
    return BookIds(
      booksModel: BooksModel.fromJson(json['booksModel']),
      docId: json['docId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booksModel': booksModel.toJson(),
      'docId': docId,
    };
  }
}

class ClothesIds {
  final ClothesModel clothesModel;
  final String docId;

  ClothesIds({required this.clothesModel, required this.docId});

  factory ClothesIds.fromJson(Map<String, dynamic> json) {
    return ClothesIds(
      clothesModel: ClothesModel.fromJson(json['clothesModel']),
      docId: json['docId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clothesModel': clothesModel.toJson(),
      'docId': docId,
    };
  }
}

final myClothesPosts = StreamProvider<List<ClothesIds>>((ref) {
  final data = FirebaseFirestore.instance
      .collection('clothes')
      .where('userID', isEqualTo:FirebaseAuth.instance.currentUser!.uid)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs.map(
          (doc) => ClothesIds(
        docId: doc.id, clothesModel:ClothesModel.fromJson(doc.data())
      ),
    ).toList(),
  );
  return data;
});