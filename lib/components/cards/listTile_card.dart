import 'package:booksexchange/controller/time_format/time_format.dart';
import 'package:booksexchange/utils/fontsize/responsive_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_theme/theme.dart';
import '../text_widget.dart';

class ListTileCard extends StatelessWidget {
  const ListTileCard({super.key,
    required this.title,
    required this.subTitle,
    required this.imageUrl,
     this.time,
    this.isError=false,
    this.isMe=false,
    this.isRead=false,
    this.hint='You',
    this.isBorder=true,
    this.isMessage=true,
    this.backgroundColor,
    this.function});

  final bool isMe;
final String title;
final bool isBorder;
final bool isRead;
final bool isMessage;
  final String subTitle;
  final String imageUrl;
  final String? time;
  final VoidCallback? function;
  final bool isError;
  final String? hint;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    bool isDark= Theme.of(context).brightness == Brightness.dark;

    return  GestureDetector(
      onTap: function,
      child: Container(
        //height: 80,
        decoration:BoxDecoration(

          borderRadius: BorderRadius.circular(5), // Rounded corners
        border: Border.all(color:isBorder &&isDark?AppThemeClass.primaryOptional:AppThemeClass.secondary, width: 1.0), // Border properties
        ),
       // margin:  EdgeInsets.only(bottom: 5),
        padding:  EdgeInsets.all(5),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                ClipOval(
                child: CachedNetworkImage(fit: BoxFit.cover, imageUrl: imageUrl,
                  width: ResponsiveBox.getSize(context, 60),
                  height:  ResponsiveBox.getSize(context, 60),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          //margin: const EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress,
                              color: AppThemeClass.primary
                          ),
                        ),
                      ),
                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                ),
              ),
                if (TimeFormater.isLessThanTenMinutesAgo(time))
                  Positioned(
                    right: 5,
                    bottom: 5,
                    child: Material(
                      elevation: 4.0, // Adjust the elevation value as needed
                      shape: CircleBorder(), // Ensures the material maintains circular shape
                      color: Colors.transparent, // Keep the container's original color
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppThemeClass.primary,
                        ),
                      ),
                    )
                  )
              ],
            ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                   // mainAxisSize: MainAxisSize.min,
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: CustomText(
                          text: isError ? "gblibrayuser" : title,
                          maxLines: 1,
                          fontSize: 15,
                          isBold: true,
                          //isGoogleFont: true,
                        ),
                      ),
                   if(time!=null)   CustomText(text: TimeFormater.timeAgo(time!.toString()), maxLines: 1,fontSize: 10,color: AppThemeClass.primary,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   // mainAxisSize: MainAxisSize.min,
                    spacing: 5,
                    children: [
                      Flexible(child: CustomText(text: isMe?'$hint: $subTitle':subTitle,maxLines: 1,fontSize: 13,)),
                      if(isMe &&isMessage)Icon(Icons.done_all,size: 20,color:  isRead?Colors.blueAccent:Theme.of(context).colorScheme.onSurface,),
                      if (!isMe && !isRead && isMessage)Material(
                        elevation: 4.0, // Adjust the elevation value as needed
                        shape: CircleBorder(), // Ensures the material maintains circular shape
                        color: Colors.transparent, // Keep the container's original color
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent,
                          ),
                          child: CustomText(text: 1.toString(),isBold: true,color: AppThemeClass.whiteText,),
                        ),

                      )


                    ],
                  )
                ],
              ),
            ),
          )
          ],
        ),
      ),
    );
  }
}
