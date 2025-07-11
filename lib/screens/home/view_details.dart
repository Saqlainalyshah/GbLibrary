import 'package:booksexchange/components/button.dart';
import 'package:booksexchange/components/layout_components/alert_dialogue.dart';
import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/controller/time_format/time_format.dart';
import 'package:booksexchange/model/post_model.dart';
import 'package:booksexchange/model/user_profile.dart';
import 'package:booksexchange/screens/chat/message_room.dart';
import 'package:booksexchange/screens/home/image_view.dart';
import 'package:booksexchange/screens/home/view_uniform.dart';
import 'package:booksexchange/utils/fontsize/responsive_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/cards/listTile_card.dart';
import '../../controller/providers/global_providers.dart';
import '../../utils/app_theme/theme.dart';

class ViewDetails extends ConsumerStatefulWidget {
  const ViewDetails({super.key, required this.booksModel});
  final BooksModel booksModel;

  @override
  ConsumerState<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends ConsumerState<ViewDetails> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref
        .read(mapDataProvider.notifier)
        .getMapData('users', widget.booksModel.userID);
  }

  @override
  Widget build(BuildContext context) {
    print("View Details Screen builds");
   final bookTitle= widget.booksModel.grade!="General Books"?"Books":'';
    return SafeArea(
      top: false,
      child: Scaffold(
      //  backgroundColor: AppThemeClass.whiteText,
        appBar: AppBar(
         // surfaceTintColor: Colors.transparent,
          //backgroundColor: Colors.transparent,
          leading: buildCustomBackButton(context),
          title: Text( "Details"),
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
                          Navigator.push(context, MaterialPageRoute(builder: (builder)=>ImageView(url: widget.booksModel.imageUrl)));
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
                            imageUrl: widget.booksModel.imageUrl,
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
                        text: widget.booksModel.category=="Exchange"? "I want to ${widget.booksModel.category} ${widget.booksModel.grade} $bookTitle":'I am donating ${widget.booksModel.grade} $bookTitle',
                        fontSize:18,
                        isBold: true,
                      ),
                      CustomText(
                        text: "Description:",
                        isBold: true,
                        color: AppThemeClass.primary,
                      ),
                      buildIconTextRowWithoutBackground(
                        Icons.access_time,
                        TimeFormater.timeAgo(
                          widget.booksModel.createdAt.toString(),
                        ),
                      ),
                      CustomText(
                        text: widget.booksModel.description,
                        fontSize: 15,
                      ),
                      CustomText(
                        text: "Total Subjects:",
                        isBold: true,
                        color: AppThemeClass.primary,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: AppThemeClass.primary,
                            width: 1.0,
                          ),
                        ),
                        child: Wrap(
                          spacing: 5.0,
                          children: widget.booksModel.subjects.map((
                              buttonText,
                              ) {
                            return OutlinedButton(
                              onPressed: () {},
                              child: Text(buttonText,),
                            );
                          }).toList(),
                        ),
                      ),
                      CustomText(
                        text: "Institute:",
                        isBold: true,
                        color: AppThemeClass.primary,
                      ),
                      buildIconTextRowWithoutBackground(
                        Icons.house_outlined,
                        widget.booksModel.board,
                      ),
                      CustomText(
                        text: "Address:",
                        isBold: true,
                        color: AppThemeClass.primary,
                      ),
                      buildIconTextRowWithoutBackground(
                        Icons.location_on,
                        widget.booksModel.location,
                      ),
                      CustomText(
                        text: "Class:",
                        isBold: true,
                        color: AppThemeClass.primary,
                      ),
                      buildIconTextRowWithoutBackground(
                        Icons.school_outlined,
                        widget.booksModel.grade,

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
                              isMessage:  false,
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
                              title: Text('gilgitswap user'),
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
                    bool isDark= Theme.of(context).brightness == Brightness.dark;

                    final data=ref.watch(mapDataProvider);
                    if(data!=null){
                      final tempData=UserProfile.fromJson(data);
                      return Row(
                        spacing: 50,
                        children: [
                          Expanded(
                            child:CustomButton(isBorder: isDark, color: isDark?AppThemeClass.primaryOptional:AppThemeClass.primary,onPress: (){
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
                            child: CustomButton(isBorder: true,color: isDark?AppThemeClass.black:AppThemeClass.whiteText,onPress: (){
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
                                 // color: AppThemeClass.whiteText,
                                  size: 25,
                                ),
                                CustomText(
                                  text: "Call",
                                //  color: AppThemeClass.whiteText,
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


Future<void> launchPhoneCall(String phoneNumber) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    throw 'Could not launch $phoneUri';
  }
}