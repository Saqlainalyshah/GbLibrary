import 'package:booksexchange/screens/home/view_details.dart';
import 'package:booksexchange/utils/fontsize/responsive_text.dart';
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
  });
  final String category;
  final String grade;
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
            Flexible(child:    buildContainerImage(context, imageUrl, 175,true),),
            Flexible(
              flex: 2,
              child: BuildPostColumn(
                category: category,
                grade: grade,
                board:
                board,
                type:type,
                description:
                description,
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
    required this.category,
    required this.grade,
  });
      final String type;
      final String board;
      final String category;
      final String grade;
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
          text: "I want to $category $grade books",
          isBold: true,
          //overflow: TextOverflow.ellipsis,
          fontSize: ResponsiveText.getSize(context, 13),
          maxLines: 1,
        ),

        buildIconTextRow(context, Icons.school, board,false),
        CustomText(
          text: description,
          //overflow: TextOverflow.ellipsis,s
          fontSize: ResponsiveText.getSize(context, 13),
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
      Flexible(child: buildIconTextRow(context, Icons.location_on, location,false)),
      buildIconTextRow(context, Icons.access_time, time,false),
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
  double size,
  bool isBorder,
) {
  return Container(
    padding: EdgeInsets.all(2),
    height: ResponsiveBox.getSize(context,size ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: isBorder
          ? Border.all(color: AppThemeClass.primary, width: .5)
          : null,
    ),
    
    child: Image.network(imageUrl,fit: BoxFit.cover,),
  );
}
///row widget wrapped in a container with a app secondary color which contains icon and text
buildIconTextRow(BuildContext context, IconData icon, String text,bool isExpend) {
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
          size: ResponsiveBox.getSize(context, 18),
        ),
        Flexible(
          child: CustomText(
            text: text,
            maxLines:isExpend? 4:1,
            fontSize: ResponsiveText.getSize(context, 12),
          ),
        ),
      ],
    ),
  );
}
