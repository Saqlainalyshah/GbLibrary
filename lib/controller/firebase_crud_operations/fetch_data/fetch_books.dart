import 'package:booksexchange/model/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/global_providers.dart';
class BookNotifier extends AsyncNotifier<FilterBooks> {
  final fireStore = FirebaseFirestore.instance;

  bool loading=false;
  bool hasMore=true;
  static const int pages=15;

  @override
  Future<FilterBooks> build() async{
    final user = ref.watch(currentUserAuthStatus).asData?.value;

    if (user != null) {
    final docs= await init(user.uid);
    final data = docs.map((doc) {
      final book = BooksModel.fromJson(doc.data() as Map<String, dynamic>);
      return book.copyWith(bookDocId: doc.id);
    }).toList();
    return FilterBooks(allBooks: data, filteredBooks: data,lastDocument: docs.last);
    }else{
      return FilterBooks(allBooks: [], filteredBooks: []);
    }

  }


  Future<List<DocumentSnapshot>> init(String uid) async {
    loading=true;

    try {
      final docs = await itemsPaginationFuture(limit: 2, uid: uid);
      loading=false;
      return docs;

    } catch (e) {
      if (kDebugMode) print("Init Error: $e");
      loading=false;
      return [];

    }

  }

  Future<void> loadMore() async {
    final currentState = state;

    if (currentState is! AsyncData<FilterBooks>) return;

    final current = currentState.value;

    final user = ref.read(currentUserAuthStatus).asData?.value;
    if (user == null) return;

    try {
      final docs = await itemsPaginationFuture(
        limit: 2,
        lastDocument: current.lastDocument,
        uid: user.uid,
      );
      print(docs.length);

      final newBooks = docs.map((doc) {
        final book = BooksModel.fromJson(doc.data() as Map<String, dynamic>);
        return book.copyWith(bookDocId: doc.id);
      }).toList();

      final updated = [...current.allBooks, ...newBooks];

      state = AsyncData(current.copyWith(
        allBooks: updated,
        filteredBooks: updated,
        lastDocument: docs.isNotEmpty ? docs.last : null,
        isBusy: false,
        isLoading: docs.isNotEmpty,
      ));
    } catch (e) {
      print("Load More Error: $e");
      state = AsyncError(e, StackTrace.current);
    }
  }



  Future<List<DocumentSnapshot>> itemsPaginationFuture({
    required int limit,
    required String uid,
    DocumentSnapshot? lastDocument,
  }) async {
    var query = FirebaseFirestore.instance
        .collection('posts')
        .where('userID', isNotEqualTo: uid)
        .orderBy('createdAt', descending: true);

    if (lastDocument != null) {
      print("Last document=========>");
      query = query.startAfterDocument(lastDocument);
    }

    final snapshot = await query.limit(limit).get();
    return snapshot.docs;
  }

  void filterByLocation(String search) {
    final currentState = state;
    if (currentState is! AsyncData<FilterBooks>) return;

    final filtered = currentState.value.allBooks
        .where((item) => item.location.toLowerCase().startsWith(search.toLowerCase()))
        .toList();

    state = AsyncData(currentState.value.copyWith(filteredBooks: filtered));
  }

  void resetFilters() {
    final currentState = state;
    if (currentState is! AsyncData<FilterBooks>) return;

    state = AsyncData(currentState.value.copyWith(
      filteredBooks: currentState.value.allBooks,
    ));
  }

}


class FilterBooks {
  final List<BooksModel> allBooks;
  final List<BooksModel> filteredBooks;
  final DocumentSnapshot? lastDocument;
  final bool isLoading;
  final bool isBusy;

  FilterBooks({
    required this.allBooks,
    required this.filteredBooks,
    this.lastDocument,
    this.isLoading = true,
    this.isBusy = false,
  });

  FilterBooks copyWith({
    List<BooksModel>? allBooks,
    List<BooksModel>? filteredBooks,
    DocumentSnapshot? lastDocument,
    bool? isLoading,
    bool? isBusy,
  }) {
    return FilterBooks(
      allBooks: allBooks ?? this.allBooks,
      filteredBooks: filteredBooks ?? this.filteredBooks,
      lastDocument: lastDocument ?? this.lastDocument,
      isLoading: isLoading ?? this.isLoading,
      isBusy: isBusy ?? this.isBusy,
    );
  }
}

final bookNotifierProvider =
AsyncNotifierProvider<BookNotifier, FilterBooks>(() => BookNotifier());


/*
final bookNotifierProvider = NotifierProvider<BookNotifier, FilterBooks>((ref) {
  final authAsync = ref.watch(currentUserAuthStatus);

  // Handle loading or error
  if (authAsync is AsyncLoading || authAsync is AsyncError || authAsync.value == null) {
    return FilterFeedNotifier.empty(); // fallback safe version
  }

  final uid = authAsync.value!.uid;
  return FilterFeedNotifier(uid);
});
*/








/*class FilterBooks{
  final List<BooksModel> allBooks;
  List<BooksModel> filteredBooks;

  FilterBooks({
    required this.allBooks,
    required this.filteredBooks,
});
}*/
/*
class FilterFeedNotifier extends StateNotifier<FilterFeed> {
  late final StreamSubscription? _sub;

  // Normal constructor
  FilterFeedNotifier(String uid) : super(FilterFeed(allFeeds: [], filteredFeeds: [])) {
    _sub = FirebaseFirestore.instance
        .collection('posts')
        .where('userID', isNotEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final books = snapshot.docs.map((doc) {
        final data = doc.data();
        return BooksModel.fromJson(data);
      }).toList();

      state = state.copyWith(allFeeds: books, filteredFeeds: books);
    });
  }

  // Empty constructor for unauthenticated fallback
  FilterFeedNotifier.empty() : _sub = null, super(FilterFeed(allFeeds: [], filteredFeeds: []));

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void filterByLocation(String search) {
    final filtered = state.allFeeds.where((item) =>
        item.location.toLowerCase().startsWith(search.toLowerCase())
    ).toList();
    state = state.copyWith(filteredFeeds: filtered);
  }

  void resetFilters() {
    state = state.copyWith(filteredFeeds: state.allFeeds);
  }
}





final filterFeedProvider = StateNotifierProvider<FilterFeedNotifier, FilterFeed>((ref) {
  final authAsync = ref.watch(currentUserAuthStatus);

  // Handle loading or error
  if (authAsync is AsyncLoading || authAsync is AsyncError || authAsync.value == null) {
    return FilterFeedNotifier.empty(); // fallback safe version
  }

  final uid = authAsync.value!.uid;
  return FilterFeedNotifier(uid);
});
*/
