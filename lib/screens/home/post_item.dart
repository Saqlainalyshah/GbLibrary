import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/text_widget.dart';
import '../../controller/providers/global_providers.dart';
import '../../model/post_model.dart';
import '../../utils/app_theme/theme.dart';
import '../user_actions/post_books.dart';
import '../user_actions/post_uniform_clothes.dart';

class PostItem extends StatelessWidget {
  const PostItem({super.key});

  @override
  Widget build(BuildContext context) {
    print("PostItem Screen Rebuilds");
    return  SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10,
          children: [

            ...List.generate(2, (index){
              final List<String> l=["Books","Uniform & Clothes "];
              final List<String> list=["Exchange or Donate your books. There are a lot of educators looking for books exchanges and books donation","Give your clothes to needy students. You can share schools uniforms"];
              return Consumer(
                builder:(context,ref,child)=> ListTile(
                  //splashColor: AppThemeClass.primary,
                  focusColor: AppThemeClass.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                          color: AppThemeClass.secondary
                      )
                  ),
                  onTap: (){
                    if(index==0){
                      ref.invalidate(bookSubjectsList);
                      ref.invalidate(bookCategory);
                      ref.invalidate(bookGrade);
                      ref.invalidate(bookBoard);
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>PostBooks(isEdit: false, booksModel: BooksModel(createdAt: DateTime.now()),)));
                    }else{
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>UniformClothesScreen(isEdit: false, clothesModel: ClothesModel(createdAt: DateTime.now()))));
                    }
                  },
                  title: Row(
                    children: [
                      Flexible(flex:1,child: Image.asset(index==1?"assets/images/uniform.png":"assets/splash/splash.png",fit: BoxFit.cover,)),
                      Flexible(flex:3,child: ListTile(
                        //  isThreeLine: true,
                        title: CustomText(text: l[index],isBold: true,fontSize: 16,),
                        subtitle: CustomText(text: list[index],maxLines: 3,),
                      )),
                      Icon(Icons.navigate_next),
                    ],
                  ),
                ),
              );
            }),
          ],

        ),
      ),
    );
  }
}