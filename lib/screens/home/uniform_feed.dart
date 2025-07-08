import 'dart:async';

import 'package:booksexchange/components/button.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/controller/time_format/time_format.dart';
import 'package:booksexchange/model/post_model.dart';
import 'package:booksexchange/screens/home/view_details.dart';
import 'package:booksexchange/screens/home/view_uniform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/cards/post_card.dart';
import '../../components/textfield.dart';
import '../../controller/providers/global_providers.dart';
import '../../utils/app_theme/theme.dart';
class UniformNotifier extends StateNotifier<ClothesData> {
  late final StreamSubscription? _sub;

  // Normal constructor
  UniformNotifier(String uid) : super(ClothesData(allFeeds: [], filteredFeeds: [])) {
    _sub = FirebaseFirestore.instance
        .collection('outfits')
        .where('userID', isNotEqualTo:uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final books = snapshot.docs.map((doc) {
        final data = doc.data();
        final raw=ClothesModel.fromJson(data);
        final model=raw.copyWith(clothesDocId: doc.id);
        return model;
      }).toList();

      state = state.copyWith(allFeeds: books, filteredFeeds: books);
    });

  }

  // Empty constructor for unauthenticated fallback
  UniformNotifier.empty() : _sub = null, super(ClothesData(allFeeds: [], filteredFeeds: []));

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



class ClothesData{
  final List<ClothesModel> allFeeds;
  final List<ClothesModel>  filteredFeeds;

  ClothesData({required this.allFeeds, required this.filteredFeeds});
  ClothesData copyWith({
    List<ClothesModel> ? allFeeds,
    List<ClothesModel> ? filteredFeeds,
  }){
    return ClothesData(allFeeds: allFeeds??this.allFeeds, filteredFeeds: filteredFeeds??this.filteredFeeds);
  }
}


final clothesProvider = StateNotifierProvider<UniformNotifier, ClothesData>((ref) {
  final authAsync = ref.watch(currentUserAuthStatus);

  // Handle loading or error
  if (authAsync is AsyncLoading || authAsync is AsyncError || authAsync.value == null) {
    return UniformNotifier.empty(); // fallback safe version
  }

  final uid = authAsync.value!.uid;
  return UniformNotifier(uid);
});



class UniformFeed extends ConsumerWidget {
   UniformFeed({super.key,});
final TextEditingController controller =TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("Feed Portion Screen Rebuilds");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 0),
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverAppBar(
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
                      ref.read(clothesProvider.notifier).filterByLocation(search);
                    },
                    trailingFn: () {
                      controller.clear();
                      ref.read(clothesProvider.notifier).resetFilters();
                    },
                  );
                },
              ),

            ),
          ),

          // Posts List
          Consumer(
            builder: (context, ref, child) {
              final all = ref.watch(clothesProvider.select((s) => s.allFeeds));
              final filtered = ref.watch(clothesProvider.select((s) => s.filteredFeeds));
              final uniformPosts = controller.text.isNotEmpty ? filtered : all;

              if (uniformPosts.isNotEmpty) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return Column(
                        children: [
                       PostCard(
                      title: uniformPosts[index].isSchoolUniform=='Yes'?"Donated School Uniform":"Donated Outfits",
                        category: '',
                        grade: '',
                        isClothes: true,
                        board: uniformPosts[index].size=='S'?'Small Size':uniformPosts[index].size=='M'?'Medium Size':uniformPosts[index].size=='L'?'Large Size':'Extra Large Size',
                        time: TimeFormater.timeAgo(uniformPosts[index].createdAt.toString()),
                        description: uniformPosts[index].description,
                        location: uniformPosts[index].location,
                        type:'',
                        imageUrl: uniformPosts[index].imageUrl,
                        function: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (builder) =>  SchoolUniformScreen(clothesModel: uniformPosts[index],)),
                          );
                        },
                      ),
                          Divider(),
                        ],
                      );
                    },
                    childCount: uniformPosts.length,
                  ),
                );

              }
              else{
                return SliverToBoxAdapter(
                  child:Center(
                    child:CircularProgressIndicator(color: AppThemeClass.primary,),
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

/*return PostCard(
                        title: uniformPosts[index].isSchoolUniform=='Yes'?"Donated School Uniform":"Donated Outfits",
                        category: '',
                        grade: '',
                        isClothes: true,
                        board: uniformPosts[index].size=='S'?'Small Size':uniformPosts[index].size=='M'?'Medium Size':uniformPosts[index].size=='L'?'Large Size':'Extra Large Size',
                        time: TimeFormater.timeAgo(uniformPosts[index].createdAt.toString()),
                        description: uniformPosts[index].description,
                        location: uniformPosts[index].location,
                        type:'',
                        imageUrl: uniformPosts[index].imageUrl,
                        function: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (builder) =>  SchoolUniformScreen(clothesModel: uniformPosts[index],)),
                          );
                        },
                      );
* */