import 'dart:async';

import 'package:booksexchange/components/button.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/controller/time_format/time_format.dart';
import 'package:booksexchange/screens/home/view_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/cards/post_card.dart';
import '../../components/textfield.dart';
import '../../controller/ads/banner_ad.dart';
import '../../controller/providers/global_providers.dart';
import '../../model/post_model.dart';
import '../../utils/fontsize/app_theme/theme.dart';

class FilterFeedNotifier extends StateNotifier<FilterFeed> {
  late final StreamSubscription? _sub;

  // Normal constructor
  FilterFeedNotifier(String uid) : super(FilterFeed(allFeeds: [], filteredFeeds: [])) {
    _sub = FirebaseFirestore.instance
        .collection('books')
        .where('userID', isNotEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final books = snapshot.docs.map((doc) {
        final data = doc.data();
        final raw=BooksModel.fromJson(data);
        final model=raw.copyWith(bookDocId: doc.id);
        return model;
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



class FilterFeed{
  final List<BooksModel> allFeeds;
  final List<BooksModel>  filteredFeeds;

  FilterFeed({required this.allFeeds, required this.filteredFeeds});
  FilterFeed copyWith({
    List<BooksModel> ? allFeeds,
    List<BooksModel> ? filteredFeeds,
  }){
    return FilterFeed(allFeeds: allFeeds??this.allFeeds, filteredFeeds: filteredFeeds??this.filteredFeeds);
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


class FeedPortion extends ConsumerWidget {
  FeedPortion({super.key,});
  final TextEditingController controller=TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("Feed Portion Screen Rebuilds");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 0),
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          /*  SliverAppBar(

            surfaceTintColor: AppThemeClass.whiteText,
            backgroundColor: AppThemeClass.whiteText,
            floating: true,
            pinned: true,
            expandedHeight: 10,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
             // padding: const EdgeInsets.symmetric(horizontal: 8.0),
              background: BannerAdWidget(),
            ),
          ),*/

          SliverAppBar(
            surfaceTintColor: AppThemeClass.whiteText,
            backgroundColor: AppThemeClass.whiteText,

            expandedHeight: 60,

            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              background:   Consumer(
                builder: (context, ref, child) {
                  return CustomTextField(
                    controller: controller,

                    hintText: "Search by location",
                    leadingIcon: Icons.search,
                    trailingIcon: Icons.close,
                    onChanged: (String search) {
                      ref.read(filterFeedProvider.notifier).filterByLocation(search);
                    },
                    trailingFn: () {
                      controller.clear();
                      ref.read(filterFeedProvider.notifier).resetFilters();
                    },
                  );
                },
              ),

            ),
          ),

          // Posts List
          Consumer(
            builder: (context, ref, child) {
              final all = ref.watch(filterFeedProvider.select((s) => s.allFeeds));
              final filtered = ref.watch(filterFeedProvider.select((s) => s.filteredFeeds));
              final posts = controller.text.isNotEmpty ? filtered : all;

              if (posts.isNotEmpty) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final post = posts[index];
                      final type = post.category;
                      return Column(
                        children: [
                          PostCard(
                            title: type == "Exchange"
                                ? "I want to ${post.category} ${post.grade} Books"
                                : "I am donating ${post.grade} Books",
                            category: post.category,
                            grade: post.grade,
                            board: post.board,
                            time: TimeFormater.timeAgo(post.createdAt.toString()),
                            description: post.description,
                            location: post.location,
                            type: post.type,
                            imageUrl: post.imageUrl,
                            function: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ViewDetails(booksModel: post),
                                ),
                              );
                            },
                          ),
                          Divider(color: AppThemeClass.primary),
                        ],
                      );
                    },
                    childCount: posts.length,
                  ),
                );

              }
              else{
                return SliverToBoxAdapter(
                  child:Column(
                    children: [
                      Center(
                        child:CircularProgressIndicator(color: AppThemeClass.primary,),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );


  }
}