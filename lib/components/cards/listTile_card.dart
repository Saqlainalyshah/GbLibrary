import 'package:booksexchange/controller/time_format/time_format.dart';
import 'package:booksexchange/utils/fontsize/responsive_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/fontsize/app_theme/theme.dart';
import '../text_widget.dart';

class ListTileCard extends StatelessWidget {
  const ListTileCard({super.key,
    required this.title,
    required this.subTitle,
    required this.imageUrl,
     this.time,
    this.isError=false,
    this.isMe=false,
    this.hint='You',
    this.function});

  final bool isMe;
final String title;
  final String subTitle;
  final String imageUrl;
  final String? time;
  final VoidCallback? function;
  final bool isError;
  final String? hint;
  @override
  Widget build(BuildContext context) {

    return  GestureDetector(
      onTap: function,
      child: Container(
        height: 100,
        decoration:BoxDecoration(
         // color: AppThemeClass.secondary,
          borderRadius: BorderRadius.circular(5), // Rounded corners
          border: Border.all(color: AppThemeClass.secondary, width: 1.0), // Border properties
        ),
        margin:  EdgeInsets.only(bottom: 10),
        //padding:  EdgeInsets.all( 0),
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
                if (time!=null &&TimeFormater.isLessThanTenMinutesAgo(time))
                  Positioned(
                    right: 10,
                    bottom: 5,
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppThemeClass.primary,
                      ),
                    ),
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
                   if(time!=null)   CustomText(text: TimeFormater.timeAgo(time!.toString()), maxLines: 1,fontSize: 10,isGoogleFont: true,color: AppThemeClass.primary,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   // mainAxisSize: MainAxisSize.min,
                    spacing: 5,
                    children: [
                      Flexible(
                        child: RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              if(isMe)TextSpan(
                                text: '$hint: ',
                                style: GoogleFonts.robotoSerif(
                                  color: AppThemeClass.primary,
                                  letterSpacing: 0,
                                  fontSize: ResponsiveText.getSize(context, 13),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: subTitle,
                                style: GoogleFonts.robotoSerif(
                                  color: AppThemeClass.darkTextOptional,
                                  letterSpacing: 0,
                                  fontSize: ResponsiveText.getSize(context, 13),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (time != null)  Icon(Icons.done_all,color: isMe?Colors.black26:Colors.blue),

                    ],
                  )
                ],
              ),
            ),
          )

           /* Expanded(
              child: Padding(
              //  color: Colors.black,
                padding: const EdgeInsets.only(top: 15.0, left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                 // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: isError ? "gblibrayuser" : title,
                      maxLines: 1,
                      fontSize: 16,
                      isBold: true,
                      //isGoogleFont: true,


                    ),
                    SizedBox(height: 4),
                    RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          if(isMe)TextSpan(
                            text: '$hint: ',
                            style: GoogleFonts.robotoSerif(
                              color: AppThemeClass.primary,
                              letterSpacing: 0,
                              fontSize: ResponsiveText.getSize(context, 13),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: subTitle,
                            style: GoogleFonts.robotoSerif(
                              color: AppThemeClass.darkTextOptional,
                              letterSpacing: 0,
                              fontSize: ResponsiveText.getSize(context, 13),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Spacer(),
            if (time != null)
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Icon(Icons.done_all,color: isMe?Colors.black26:Colors.blue),
                CustomText(text: TimeFormater.timeAgo(time!.toString()), maxLines: 1,fontSize: 10,isGoogleFont: true,color: AppThemeClass.primary,),
              ],),
            SizedBox(width: 3,),*/

          ],
        ),
      ),
    );
  }
}
