import 'package:booksexchange/components/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/cards/post_card.dart';
import '../../utils/fontsize/app_theme/theme.dart';
class MyPosts extends StatelessWidget {
   MyPosts({super.key});
final _index= StateProvider.autoDispose<int>((ref)=>0);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            title: CustomText(text: "My Posts",isBold: true,fontSize: 20,),
          ),
          body: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 3,
                padding: EdgeInsets.all(5),
                itemBuilder: (context,index){
                  print("index");
                  return PostCard(title: '${index+1}th' , board: 'Kiu Board', time: ' 2 minutes ago', description:" bookExchangeMessages[index]", location: 'Jutial,Gilgit', numberOfBooks: 8, imageUrl: 'Nope',);
                }, separatorBuilder: (BuildContext context, int index) {
                return Divider(color: AppThemeClass.primary,);
              },),
            ],
          ),
    ));
  }
}
