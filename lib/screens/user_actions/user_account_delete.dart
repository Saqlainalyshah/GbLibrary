import 'package:booksexchange/components/layout_components/alert_dialogue.dart';
import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/controller/firebase_Storage/crud_storage.dart';
import 'package:booksexchange/controller/firebase_crud_operations/firestore_crud_operations.dart';
import 'package:booksexchange/controller/providers/global_providers.dart';
import 'package:booksexchange/model/chat_model.dart';
import 'package:booksexchange/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/authentication/auth_repository.dart';
import '../../utils/app_theme/theme.dart';
import '../chat/chat.dart';

class AccountSecurity extends StatelessWidget {
  const AccountSecurity({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          leading: buildCustomBackButton(context),
          title: CustomText(text: "Account",fontSize: 20,isBold: true,),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,

            children: [
              CustomText(text: "Settings",isBold: true,fontSize: 15,),
              Consumer(
                builder:(context,ref,child){
                  final theme=ref.watch(themeNotifierProvider);
                  final isDark=theme==ThemeMode.dark;
                  return SwitchListTile(
                      inactiveThumbColor: AppThemeClass.primary,
                  title:   CustomText(text: "Switch to Dark Mode",isBold: true,fontSize: 15,),value: isDark, onChanged: (val){
                    final notifier=ref.read(themeNotifierProvider.notifier);
                    notifier.toggleTheme();

                  });
                },
              ),
              Consumer(
                builder:(context,ref, child)=> ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                          color: ref.watch(themeNotifierProvider)==ThemeMode.dark? AppThemeClass.primaryOptional:AppThemeClass.primary
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
                          final myChats=ref.watch(filterChatProvider.select((state)=>state.allChats));
                          final myBooks = await ref.read(myBooksPosts.future);

                          final myClothes= await ref.read(myClothesPosts.future);
                          if(user!=null){
                            UiEventHandler.customAlertDialog(context, "Wait a few minutes we're deleting...", '', "", "", (){}, true);

                            for(var item in myChats){
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
                              temp.remove(user.uid);
                              final model=chat.copyWith(chatDocId: '',participants: temp);
                              await instance.updateDocument('chats', item.chatDocId, model.toJson());
                            }

                            if(myBooks.isNotEmpty){
                              for(var item in myBooks){
                                final onValue= await storageService.deleteFile(item.imageUrl);
                                if(onValue){
                                  await instance.deleteDocument('books', item.bookDocId);
                                }
                              }
                            }
                            if(myClothes.isNotEmpty){
                              for(var item in myClothes){
                                final onValue= await storageService.deleteFile(item.imageUrl);
                                if(onValue){
                                  await   instance.deleteDocument('outfits', item.clothesDocId);
                                }
                              }
                            }
                            if(context.mounted){
                              Navigator.of(context).pop();
                            }
                            AuthRepository auth=AuthRepository();
                              await auth.deleteAccount();
                            Navigator.of(context).pop();
                          }
                        }, false);
                  },
                  title: CustomText(text: "Delete Account",isBold: true,fontSize: 16,),
                  subtitle: CustomText(text: "Once you delete your account all your data will be deleted permanently"),
                  trailing: Icon(Icons.delete,color: Colors.red,size: 30,),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
