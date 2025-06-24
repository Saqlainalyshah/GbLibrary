import 'package:booksexchange/screens/home/image_view.dart';
import 'package:booksexchange/screens/home/view_details.dart';
import 'package:booksexchange/utils/fontsize/responsive_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/fontsize/app_theme/theme.dart';
import '../button.dart';
import '../text_widget.dart';

/// card to display posts
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.category,
    required this.grade,
    required this.board,
    required this.time,
    required this.description,
    required this.location,
    required this.type,
    required this.imageUrl,
    required this.function,
    required this.title
  });
  final String category;
  final String grade;
  final String title;
  final String board;
  final String time;
  final String description;
  final String location;
  final String type;
  final String imageUrl;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [

        Row(
         crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
           GestureDetector(
             onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (builder)=>ImageView(url: imageUrl)));
             },
             child:  buildContainerImage(context, imageUrl, 150,100,true),),
            Flexible(
              flex: 3,
              child: BuildPostColumn(
                title: title,
                board: board,
                type:type,
                description: description,
              ),
            )
          ],
        ),
        Flexible(child: _buildBottomRow(context, location, time,function)),
      ],
    );
  }
}
///Right side portion of card like title, board and dcription
class BuildPostColumn extends StatelessWidget {
  const BuildPostColumn({
    super.key,
    required this.type,

    required this.board,
    required this.description,
    required this.title,

  });
      final String type;
      final String board;
      final String title;

      final String description;
  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        CustomText(
          text: title,
          isBold: true,
          //overflow: TextOverflow.ellipsis,
          fontSize:14,
          maxLines: 1,
        ),

        buildIconTextRow( Icons.school, board,false),
        CustomText(
          text: description,
          //overflow: TextOverflow.ellipsis,s
          fontSize: 13,
          maxLines: 5,
        ),
      ],
    );
  }
}
///bottom row of card which contains location, time and view details button
_buildBottomRow(BuildContext context, String location, String time, Function function) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    spacing: 5,
    //mainAxisSize: MainAxisSize.min,
    children: [
      Flexible(child: buildIconTextRow( Icons.location_on, location,false)),
      Flexible(child: buildIconTextRow( Icons.access_time, time,false),),
      CustomButton(
       // isBorder: false,
        radius: 5,
        onPress: () {
         function();
        },
        title: 'View Details',
        width: ResponsiveBox.getSize(context, 120),
        height: ResponsiveBox.getSize(context, 40),
      ),
    ],
  );
}


///Container to show image with border or without border
buildContainerImage(
  BuildContext context,
  String imageUrl,
  double height,
    double width,
  bool isBorder,
) {
  return Container(
    padding: EdgeInsets.all(2),
    height: ResponsiveBox.getSize(context,height ),
    width: ResponsiveBox.getSize(context, width),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: isBorder
          ? Border.all(color: AppThemeClass.primary, width: .5)
          : null,
    ),
    child: CachedNetworkImage(fit: BoxFit.cover, imageUrl: imageUrl,
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
  );
}
///row widget wrapped in a container with a app secondary color which contains icon and text
buildIconTextRow(IconData icon, String text,bool isExpend) {
  return Container(
   // width: double.infinity,
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: AppThemeClass.secondary,
      borderRadius: BorderRadius.circular(3),
    ),
    child: Row(
      spacing: 3,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppThemeClass.primary,
          size: 20,
        ),
        Flexible(
          child: CustomText(
            text: text,
            maxLines:isExpend? 4:1,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
