import 'package:booksexchange/components/button.dart';
import 'package:booksexchange/components/cards/post_card.dart';
import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/controller/time_format/time_format.dart';
import 'package:booksexchange/model/post_model.dart';
import 'package:booksexchange/model/user_profile.dart';
import 'package:booksexchange/screens/chat/message_room.dart';
import 'package:booksexchange/screens/home/image_view.dart';
import 'package:booksexchange/screens/home/view_details.dart';
import 'package:booksexchange/utils/fontsize/responsive_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/cards/listTile_card.dart';
import '../../components/layout_components/alert_dialogue.dart';
import '../../controller/providers/global_providers.dart';
import '../../utils/app_theme/theme.dart';

class SchoolUniformScreen extends ConsumerStatefulWidget {
  const SchoolUniformScreen({super.key, required this.clothesModel});
  final ClothesModel clothesModel;

  @override
  ConsumerState<SchoolUniformScreen> createState() => _SchoolUniformScreenState();
}

class _SchoolUniformScreenState extends ConsumerState<SchoolUniformScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref
        .read(mapDataProvider.notifier)
        .getMapData('users', widget.clothesModel.userID);
  }

  @override
  Widget build(BuildContext context) {
    print("View Details Screen builds");
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppThemeClass.whiteText,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          leading: buildCustomBackButton(context),
          title: CustomText(text: "Details"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      GestureDetector(
                        onTap:(){
                          Navigator.push(context, MaterialPageRoute(builder: (builder)=>ImageView(url: widget.clothesModel.imageUrl)));
                        },
                        child: Container(
                          padding: EdgeInsets.all(2),
                          height: ResponsiveBox.getSize(context, 400),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: AppThemeClass.primary,
                              width: .5,
                            ),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.clothesModel.imageUrl,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                //margin: const EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  color: AppThemeClass.primary,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Center(child: Icon(Icons.error)),
                          ),
                        ),
                      ),
                      CustomText(
                        text: "Title:",
                        isBold: true,
                        color: AppThemeClass.primary,
                      ),
                      CustomText(
                        text:
                        widget.clothesModel.isSchoolUniform=='Yes'? "Donated School Uniform":"Donated Clothes",
                        fontSize: ResponsiveText.getSize(context, 18),
                        isBold: true,
                      ),
                      CustomText(
                        text: "Description:",
                        isBold: true,
                        color: AppThemeClass.primary,
                      ),
                      buildIconTextRow(context,
                        Icons.access_time,
                        TimeFormater.timeAgo(
                          widget.clothesModel.createdAt.toString(),
                        ),
                        true,
                      ),
                      CustomText(
                        text: widget.clothesModel.description,
                        fontSize: 14,
                      ),
                      CustomText(
                        text: "Size:",
                        isBold: true,
                        color: AppThemeClass.primary,
                      ),
                      buildIconTextRow(context,
                        Icons.person_outline,
                        widget.clothesModel.size=='S'?'Small Size':widget.clothesModel.size=='M'?'Medium Size':widget.clothesModel.size=='L'?'Large Size':'Extra Large Size',
                        true,
                      ),

                      CustomText(
                        text: "Address:",
                        isBold: true,
                        color: AppThemeClass.primary,
                      ),
                      buildIconTextRow(context,
                        Icons.location_on,
                        widget.clothesModel.location,
                        true,
                      ),

                      Divider(color: AppThemeClass.primary),
                      CustomText(
                        text: "About User:",
                        fontSize: 18,
                        isBold: true,
                        color: AppThemeClass.primary,
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final temp = ref.watch(mapDataProvider);
                          if (temp != null) {
                            final user = UserProfile.fromJson(temp);
                            return ListTileCard(
                              title: user.name,
                              subTitle:
                              "Member since ${TimeFormater.formatIsoDate(user.createdAt.toString())}",
                              imageUrl: user.profilePicUrl,
                            );
                          } else {
                            return ListTile(
                              leading: Icon(
                                Icons.person_search,
                                size: 50,
                                color: AppThemeClass.primaryOptional,
                              ),
                              title: Text('gblibraryuser'),
                              subtitle: Text("User Not Found"),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(8.0),
                child: Consumer(
                  builder:(context,ref,child){
                    final data=ref.watch(mapDataProvider);
                    if(data!=null){
                      final tempData=UserProfile.fromJson(data);
                      return Row(
                        spacing: 50,
                        children: [
                          Expanded(
                            child:CustomButton(onPress: (){
                              Navigator.push(context, MaterialPageRoute(builder: (builder)=>MessageRoom(userProfile:tempData ,)));
                            },widget: Row(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat,
                                  color: AppThemeClass.whiteText,
                                  size: 25,
                                ),
                                CustomText(
                                  text: "Chat",
                                  color: AppThemeClass.whiteText,
                                  isBold: true,
                                  fontSize: 18,
                                ),
                              ],
                            ),),
                          ),
                          Expanded(
                            child: CustomButton(color: AppThemeClass.whiteText,isBorder: true,onPress: (){
                              if(tempData.number.length==11){
                                launchPhoneCall(tempData.number);
                              }else{
                                UiEventHandler.snackBarWidget(context, "User doesn't provided number");
                              }
                            },widget: Row(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.call,
                                  color: AppThemeClass.darkText,
                                  size: 25,
                                ),
                                CustomText(
                                  text: "Call",
                                  color: AppThemeClass.darkText,
                                  isBold: true,
                                  fontSize: 18,
                                ),
                              ],
                            ),),
                          )
                        ],
                      );
                    }else{
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
