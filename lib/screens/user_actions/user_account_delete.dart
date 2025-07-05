import 'package:booksexchange/components/layout_components/alert_dialogue.dart';
import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/controller/firebase_Storage/crud_storage.dart';
import 'package:booksexchange/controller/firebase_crud_operations/firestore_crud_operations.dart';
import 'package:booksexchange/controller/providers/global_providers.dart';
import 'package:booksexchange/model/chat_model.dart';
import 'package:booksexchange/model/message_model.dart';
import 'package:booksexchange/model/post_model.dart';
import 'package:booksexchange/utils/fontsize/app_theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/authentication/auth_repository.dart';
import '../chat/chat.dart';

class AccountSecurity extends StatelessWidget {
  const AccountSecurity({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppThemeClass.whiteText,
        appBar: AppBar(
          surfaceTintColor: AppThemeClass.whiteText,
          backgroundColor: Colors.transparent,
          leading: buildCustomBackButton(context),
          title: CustomText(text: "Account",fontSize: 20,isBold: true,),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer(
            builder:(context,ref, child)=> ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(
                      color: AppThemeClass.secondary
                  )
              ),
              onTap: () {
                UiEventHandler.customAlertDialog(context, "Are you sure to delete permanently?", "Once you delete your account all your data will be deleted permanently", 'Delete',
                    'Cancel', () async{
                  Navigator.of(context).pop();
                  FirebaseFireStoreServices instance=FirebaseFireStoreServices();
                  FirebaseFirestore db=FirebaseFirestore.instance;
                  FirebaseStorageService storageService=FirebaseStorageService();
                  final user=ref.watch(userProfileProvider);
                  final myChats=ref.watch(filterChatProvider);
                  final myBooks=ref.watch(myBooksPosts);
               if(user!=null){
                 UiEventHandler.customAlertDialog(context, "Wait a few minutes we're deleting...", '', "", "", (){}, true);
                 for(var item in myChats.allChats){
                   final List<MessageModel> snapshot = await db
                       .collection('chats/${item.chatDocId}/messages') // Replace with your actual collection name
                       .where('userId', isEqualTo: user.uid)
                       .get().then((onValue){
                         return onValue.docs.map((doc){
                           final decode=MessageModel.fromJson(doc.data());
                           final model=decode.copyWith(messageDocId: doc.id);
                           return model;
                         }).toList();
                   });
                   // Delete each matching document
                   for (var doc in snapshot) {
                     await instance.deleteDocument('chats/${item.chatDocId}/messages', doc.messageDocId);
                   }
                   ChatRoomModel chat=item;
                    List<String> temp=List.from(chat.participants);
                   print("Before================>$temp");
                   temp.remove(user.uid);
                   print(" After================>$temp");
                   final model=chat.copyWith(chatDocId: '',participants: temp);
                   print(model);
                  await instance.updateDocument('chats', item.chatDocId, model.toJson());
                 }
                 final QuerySnapshot query1 = await db
                     .collection('books') // Replace with your actual collection name
                     .where('userID', isEqualTo: user.uid)
                     .get();
                 List<BooksModel> list1=query1.docs.map((document){
                   final decoded=document.data();
                   final parse=BooksModel.fromJson(decoded as Map<String,dynamic>);
                 final model=  parse.copyWith(bookDocId: document.id);
                 return model;
                 }).toList();
                 // Delete each matching document
                 print("======================Books $list1");
                 for(var item in list1){
                 //  final path=storageService.extractFirebasePath(item.imageUrl);
                 //  print("======================outsider: $path");
                 final onValue= await storageService.deleteFile(item.imageUrl);
                 if(onValue){
                   instance.deleteDocument('book', item.bookDocId);
                 }else{
                   print("======================outsider: $onValue");
                 }
                 }
                 final QuerySnapshot query2 = await db
                     .collection('outfits') // Replace with your actual collection name
                     .where('userID', isEqualTo: user.uid)
                     .get();
                 List<ClothesModel> list2=query2.docs.map((document){
                   final decoded=document.data();
                   final parse=ClothesModel.fromJson(decoded as Map<String,dynamic>);
                   final model=  parse.copyWith(clothesDocId: document.id);
                   return model;
                 }).toList();
                 // Delete each matching document
                 for(var item in list2){

                   await storageService.deleteFile(item.imageUrl).then((onValue){
                     if(onValue){
                       instance.deleteDocument('outfits', item.clothesDocId);
                     }else{
                     }
                   });

                 }
                 if(context.mounted){
                   Navigator.of(context).pop();
                 }
                 AuthRepository auth=AuthRepository();
               //  auth.deleteAccount();
                 Navigator.of(context).pop();
               }
                }, false);
              },
              title: CustomText(text: "Delete Account",isBold: true,fontSize: 16,),
              subtitle: CustomText(text: "Once you delete your account all your data will be deleted permanently"),
              trailing: Icon(Icons.delete,color: Colors.red,size: 30,),
            ),
          ),
        ),
      ),
    );
  }
}


/// Alert dialogue to user logout action
void _showLogout(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppThemeClass.whiteText,
        surfaceTintColor: AppThemeClass.whiteText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 10,
        // content: Text("Please wait verification is in process"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            CustomText(text: "Permanent Delete " ,fontSize: 20,isBold: true,),
            CustomText(text: "Are you sure you want to delete your account?" ,fontSize: 15,),
            Row(
              spacing: 25,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Consumer(
                  builder:(context,ref,child)=>InkWell(
                      onTap: (){
                        Navigator.pop(context);
                       // UiEventHandler.customAlertDialog(context, "Deleting Account...", CircularProgressIndicator(color: AppThemeClass.primary,));
                        //final result=
                        AuthRepository auth=AuthRepository();
                        auth.deleteAccount().whenComplete((){
                         print("object");
                       });
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CustomText(text: "Delete",isBold: true,fontSize: 15,color: AppThemeClass.primary,),
                      )),
                ),
                InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomText(text: "Cancel",isBold: true,fontSize: 15,color: AppThemeClass.primary,),
                    )),
              ],
            )

          ],
        ),
      );
    },
  );
}
