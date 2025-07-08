import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../screens/home/feed_portion.dart';
import '../authentication/auth_repository.dart';
import '../firebase_crud_operations/firestore_crud_operations.dart';
import 'package:booksexchange/model/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/post_model.dart';

class MapDataNotifier extends StateNotifier<Map<String,dynamic>?>{
  MapDataNotifier():super(null);

  getMapData(String collectionPath, String uid) async{
    FirebaseFireStoreServices instance=FirebaseFireStoreServices();
    final documentSnapshot=await instance.getDoc(collectionPath, uid);
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



class UserNotifier extends StateNotifier<UserProfile?> {
  UserNotifier() : super(null);

  Future<void> fetchUser(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    state = UserProfile.fromJson(doc.data()!);
  }
  setState( UserProfile user){
    state=user;
  }
}

final userProfileProvider = StateNotifierProvider<UserNotifier, UserProfile?>((ref) => UserNotifier());


final uniformFeedProvider = StreamProvider<List<ClothesModel>>((ref) {
  //final user=FirebaseAuth.instance.currentUser;

  final user=ref.watch(currentUserAuthStatus).asData?.value;
  if(user!=null){
    return FirebaseFirestore.instance
        .collection('outfits')
        .where('userID', isNotEqualTo:user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ClothesModel.fromJson(data);
      }).toList();
    });
  }else{
    return FirebaseFirestore.instance
        .collection('outfits')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ClothesModel.fromJson(data);
      }).toList();
    });
  }
});


final myBooksPosts = StreamProvider<List<BooksModel>>((ref) {
  final user=ref.watch(currentUserAuthStatus).asData?.value;
  if(user!=null){
    return FirebaseFirestore.instance
        .collection('books')
        .where('userID', isEqualTo:user.uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(
            (doc) {
              final raw=BooksModel.fromJson(doc.data());
             final model= raw.copyWith(bookDocId: doc.id);
             return model;
            },
      ).toList(),
    );
  }
  return Stream.value([]);
});



final myClothesPosts = StreamProvider<List<ClothesModel>>((ref) {
  final user=ref.watch(currentUserAuthStatus).asData?.value;
  if(user!=null){
    return FirebaseFirestore.instance
        .collection('outfits')
        .where('userID', isEqualTo:user.uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(
            (doc) {
              final raw=ClothesModel.fromJson(doc.data());
              final model=raw.copyWith(clothesDocId: doc.id);
              return model;
            }
      ).toList(),
    );
  }else{
    return Stream.value([]);
  }

});